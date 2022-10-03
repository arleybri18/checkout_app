# frozen_string_literal: true

require_relative "product"
require_relative "pricing_rule"
require_relative "bogof_rule"
require_relative "percentage_discount_rule"
require_relative "price_discount_rule"

# This class represents a checkout and allows to you add products from your basket
# and calculate the final price.
# You can add an array of pricing rules objects to take in account in the calculation
class Checkout
  attr_reader :pricing_rules, :items

  def initialize(pricing_rules = [])
    @pricing_rules = pricing_rules
    @items = []
    @total = 0
  end

  # This method receives a product object and adds it to the items array
  #
  # ==== Attributes
  #
  # * +item+ - Product object, that represents one product from the basket
  #
  def scan(item)
    @items << item
  end

  # This method calls the logic to calculate the total price of the checkout, and modify the @total attribute
  #
  def total
    calculate_total
  end

  private

  # This method validates if exist pricing_rules to calculate the total price, or calculate
  # the total price using the sum_prices method
  #
  def calculate_total
    if pricing_rules.empty?
      @total = sum_prices(items)
    else
      @total = apply_pricing_rules
    end
  end

  # This method validate the pricing rules and calls the calculate_total method of the rule to get
  # the value for teh products, accumulated this value in the subtotal variable.
  # returns the total result of the pricing rules plus the sum_prices of the items without rules.
  #
  def apply_pricing_rules
    grouped_items = group_items
    subtotal = 0
    pricing_rules.each do |rule|
      subtotal += rule.calculate_total(grouped_items[rule.product])
    end

    items_whithout_rules = items.select {|i| !pricing_rules.map(&:product).include?(i) }
    subtotal + sum_prices(items_whithout_rules)
  end

  # This method takes the items array and counts the repetitions, returns a hash
  # containing the product as a key, and the quantity as a value.
  #
  def group_items
    items.each_with_object(Hash.new(0)) {|item, h| h[item] += 1}
  end

  # This method takes the items array and sum the prices
  #
  # ==== Attributes
  #
  # * +items+ - list of product objects
  def sum_prices(items)
    items.reduce(0) {|sum, item| sum + item.price }
  end
end
