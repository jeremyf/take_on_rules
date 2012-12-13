class Order < ActiveRecord::Base
  attr_accessible :order_number, :ordered_at, :product_model, :customer_number

  validates :order_number, presence: true, uniqueness: { scope: [:product_model] }
  validates :product_model, presence: true

  monetize :sell_price_cents, allow_nil: true
  monetize :earnings_cents, allow_nil: true

  scope :with_weekday_index, lambda { |i|
    where("strftime('%w', ordered_at) = ?", i.to_s)
  }

  def self.report
    Axlsx::Package.new do |p|
      p.workbook.add_worksheet(:name => "Bar Chart") do |sheet|
        sheet.add_row ["Simple Bar Chart"]
        %w(Sun Mon Tue Wed Thu Fri Sat).each_with_index { |label, index|
          sheet.add_row [label, index, Order.with_weekday_index(index).count ]
        }
        sheet.add_chart(Axlsx::Bar3DChart, show_legend: false, start_at: [0,5], end_at: [7, 25], title: "Sales by Day") do |chart|
          chart.add_series(
            data: sheet["C2:C8"],
            labels: sheet["A2:A8"],
            colors: ['1982D1']*7
          )
          chart.bar_dir = :col
          chart.valAxis.label_rotation = -45
        end
      end
      p.serialize('simple.xlsx')
      `open simple.xlsx`
    end
  end

end
