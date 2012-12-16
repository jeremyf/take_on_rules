Want to generate some spiffy charts for your RPG Now sales?

Download your RPGNow [sales report](http://www.rpgnow.com/pub_sales_report.php)
```
  $ git://github.com/jeremyf/take_on_rules.git
  $ cd take_on_rules
  $ rake db:create
  $ rake db:migrate
  $ cp /path/to/your/rpgnow/report.csv ./tmp/order.csv
  $ rails runner script/import.rb
```

What will this do?

It will generate an Excel document with four graphs:

* Sales by Price
* Sales by Item
* Sales by Year/Month
* Sales by Weekday