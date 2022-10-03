#!/usr/bin/env ruby

require_relative "../lib/product"
require_relative "../lib/checkout"
require_relative "../lib/pricing_rule"
require_relative "../lib/bogof_rule"
require_relative "../lib/percentage_discount_rule"
require_relative "../lib/price_discount_rule"

run = true
products = {}
pricing_rules = []
while run
  main_menu = <<~EOS
  ----------------------------------- WELCOME TO CHECKOUT APP -----------------------------------
  1. Create products.
  2. Create pricing rule.
  3. Create checkout.
  4. exit.
  ------------------------------------------------------------------------------------------
  EOS

  puts main_menu
  print "Choose an option: "
  option = (gets.chomp).to_i


  case option
  when 1

      product_menu = <<~EOS
      ------------------------------------- PRODUCTS -------------------------------------------
      To create product you need to provide the following parameters: code, name, price(decimal)
      ------------------------------------------------------------------------------------------
      EOS
      puts product_menu
      print "Type a code: "
      code = (gets.chomp)
      print "Type a name: "
      name = (gets.chomp)
      print "Type a price: "
      price = (gets.chomp).to_f
      product = Product.new(code, name, price)
      products[code] = product
      puts "Created"
      p products
  when 2
    rules_menu = <<~EOS
    ------------------------------------- PRICING RULES -------------------------------------------
    To create a new rule you need to provide the following parameters: product_code (existent) and
    choose a type of rule
    ------------------------------------------------------------------------------------------
    EOS

    puts rules_menu
    print "Type a product code: "
    product_code = (gets.chomp)
    print "Type a kind of rule, please write BogofRule , PercentageDiscountRule or PriceDiscountRule: "
    type = (gets.chomp)
    options = {}
    if type == "PercentageDiscountRule"
      print "Type minimum quantity of products to start to apply the discount: "
      min_quantity = (gets.chomp).to_i
      print "Type percentage value (decimal, fractional): "
      percentage = (gets.chomp).to_f
      options = {min_quantity: min_quantity, percentage: percentage}
    elsif type == "PriceDiscountRule"
      print "Type minimum quantity of products to start to apply the discount: "
      min_quantity = (gets.chomp).to_i
      print "Type new value for the products: "
      new_price = (gets.chomp).to_f
      options = {min_quantity: min_quantity, new_price: new_price}
    end
    klass = Module.const_get type
    product = products[product_code]
    pricing_rule = klass.new(product, options)
    pricing_rules = [pricing_rule]
    puts "Created"
    p pricing_rule
  when 3
    checkout_menu = <<~EOS
    ------------------------------------- CHECKOUT MENU -------------------------------------------
    To create a checkout start to scan products, when you need exit and calculate total, type exit
    ------------------------------------------------------------------------------------------
    EOS

    co = Checkout.new(pricing_rules)
    puts checkout_menu
    loop do
      print "Type a product code: "
      product_code = (gets.chomp)
      break if product_code == "exit"
      product = products[product_code]
      co.scan(product)
    end

    puts "THE TOTAL PRICE IS: #{co.total}"

  when 4
    run = false
  else
    puts "Please, choose a valid option"
  end
end
