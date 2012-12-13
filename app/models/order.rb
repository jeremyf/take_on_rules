class Order < ActiveRecord::Base
  attr_accessible :order_number, :ordered_at, :product_model, :customer_number

  validates :order_number, presence: true, uniqueness: { scope: [:product_model] }
  validates :product_model, presence: true

  monetize :sell_price_cents, allow_nil: true
  monetize :earnings_cents, allow_nil: true

end