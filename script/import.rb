def parse_csv
  require 'csv'
  require File.expand_path('../../app/models/order', __FILE__)

  Order.transaction do
    CSV.foreach(Rails.root.join('tmp/orders.csv')) do |row|
      unless @read_first_line
        @read_first_line = true
        next
      end
      next if row[4].to_s.strip == ''
      order = Order.new.tap { |o|
        o.order_number =  row[0]
        o.customer_number =  row[1]
        o.ordered_at =  row[2]
        o.product_model =  row[4]
        o.product_name = row[5]
        o.sell_price =  row[6]
        o.earnings =  row[10]
      }
      order.save! if order.valid?
    end
  end
end

parse_csv
puts Order.all.sum(&:earnings)
Order.report
