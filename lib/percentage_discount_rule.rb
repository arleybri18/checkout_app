# frozen_string_literal: true

# This class inherit from PricingRule class, implement the calculation method to allow apply
# discount prices to a product based in the quantity and options hash.
# Create a new object for this class sending a option hash with +min_quantity+ and +percentage+ information.
#
require_relative "pricing_rule"

class PercentageDiscountRule < PricingRule

  # This method takes the quantity of the product, use the product and options
  # information. If the quantity is greather or equal than the min_quantity,
  # it will calculate the new_price for the product using the percentage value, if not it will take the product.price stored
  #
  # ==== Attributes
  #
  # * +quantity+ - quantity of the product
  #
  # ==== Options
  #
  # * +min_quantity+ - minimal quantity of the product that needs to be in the checkout to apply discount
  # * +percentage+ - is a decimal value (i.e. 0.5) that needs to calculate the new price of the product
  def calculate_total(quantity)
    if quantity >= options[:min_quantity]
      new_price = options[:percentage] * product.price
      (new_price * quantity).round(2)
    else
      product.price * quantity
    end
  end
end
