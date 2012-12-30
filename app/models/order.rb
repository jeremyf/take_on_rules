class Order < ActiveRecord::Base
  attr_accessible :order_number, :ordered_at, :product_model, :customer_number

  validates :order_number, presence: true, uniqueness: { scope: [:product_model] }
  validates :product_model, presence: true

  monetize :sell_price_cents, allow_nil: true
  monetize :earnings_cents, allow_nil: true
  scope :not_free, where("earnings_cents > ?", 0)
  class Reporter
    def call
      Axlsx::Package.new do |p|
        p.workbook.add_worksheet(:name => "Bar Chart") do |sheet|
          @sheet = sheet
          @previous_end_row = 0
          sales_by_price(start_at: [0,0], end_at: [5, 19])
          sales_by_item(start_at: [0,20], end_at: [5, 39])
          sales_by_year_month(start_at: [0,40], end_at: [5, 59])
          sales_by_weekday(start_at: [0,60], end_at: [5, 79])
          sales_by_hour(start_at: [0,80], end_at: [5, 99])
        end
        filename = Rails.root.join('tmp/simple.xlsx')
        p.serialize(filename)
        `open #{filename}`
      end
    end

    protected
    def sales_by_price(chart_options = {})
      chart_options[:title] = "Sales by Price"
      raw_data = Order.not_free.group("sell_price_cents").count
      data = []
      raw_data.each_with_object(data) {|rd,mem| mem << [rd[0].to_f/100, rd[1]] }
      render_chart_and_return_end_row(data, chart_options)
    end

    def sales_by_item(chart_options = {})
      chart_options[:title] = "Sales by Item"
      data = Order.not_free.select("product_name").group("product_name").count
      render_chart_and_return_end_row(data, chart_options)
    end

    def sales_by_year_month(chart_options = {})
      chart_options[:title] = "Sales by Year/Month"
      data = Order.not_free.group("strftime('%Y-%m', ordered_at)").count
      render_chart_and_return_end_row(data, chart_options)
    end

    def sales_by_weekday(chart_options = {})
      chart_options[:title] = "Sales by Weekday"
      raw_data = Order.not_free.group("strftime('%w', ordered_at)").count
      data = []
      raw_data.each_with_object(data) {|rd,mem| mem << [Date::ABBR_DAYNAMES[rd[0].to_i], rd[1]] }
      render_chart_and_return_end_row(data, chart_options)
    end

    def sales_by_hour(chart_options = {})
      chart_options[:title] = "Sales by Hour"
      data = Order.not_free.group("strftime('%H', ordered_at)").count
      render_chart_and_return_end_row(data, chart_options)
    end

    def render_chart_and_return_end_row(data, chart_options)
      chart_options.reverse_merge!(show_legend: false)
      @sheet.add_row [chart_options.fetch(:title)]
      data.each {|label,count|
        @sheet.add_row [label, count]
      }
      start_row = @previous_end_row + 2
      end_row = start_row + data.size - 1
      @sheet.add_chart(Axlsx::Bar3DChart, chart_options) do |chart|
        chart.add_series(
          data: @sheet["B#{start_row}:B#{end_row}"],
          labels: @sheet["A#{start_row}:A#{end_row}"],
          colors: ['1982D1']*data.size
        )
        chart.bar_dir = :col
        chart.valAxis.label_rotation = -45
      end
      @previous_end_row = end_row
    end
  end

  def self.report
    Reporter.new.call
  end

end
