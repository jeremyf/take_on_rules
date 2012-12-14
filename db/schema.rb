# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121212214024) do

  create_table "orders", :force => true do |t|
    t.integer  "order_number"
    t.integer  "customer_number"
    t.datetime "ordered_at"
    t.string   "product_model"
    t.string   "product_name"
    t.integer  "sell_price_cents",    :default => 0,     :null => false
    t.string   "sell_price_currency", :default => "USD", :null => false
    t.integer  "earnings_cents",      :default => 0,     :null => false
    t.string   "earnings_currency",   :default => "USD", :null => false
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "orders", ["customer_number"], :name => "index_orders_on_customer_number"
  add_index "orders", ["order_number", "product_model"], :name => "index_orders_on_order_number_and_product_model", :unique => true
  add_index "orders", ["ordered_at"], :name => "index_orders_on_ordered_at"
  add_index "orders", ["product_model"], :name => "index_orders_on_product_model"
  add_index "orders", ["product_name"], :name => "index_orders_on_product_name"

end
