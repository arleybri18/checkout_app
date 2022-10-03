# frozen_string_literal: true

# This class inherit from PricingRule class, implement the calculation method to allow apply
# discount prices to a product based in the quantity and options hash.
# Create a new object for this class sending a option hash with +min_quantity+ and +new_price+ information.
#
require_relative "pricing_rule"

class PriceDiscountRule < PricingRule

  # This method takes the quantity of the product, use the product and options
  # information. If the quantity is greather or equal than the min_quantity,
  # it will take the new_price for the product, if not it will take the product.price stored
  #
  # ==== Attributes
  #
  # * +quantity+ - quantity of the product
  #
  # ==== Options
  #
  # * +min_quantity+ - minimal quantity of the product that needs to be in the checkout to apply discount
  # * +new_price+ - new price of the product if apply the discount
  def calculate_total(quantity)
    raise options_error and return unless options[:min_quantity] && options[:new_price]

    if quantity >= options[:min_quantity]
      options[:new_price] * quantity
    else
      product.price * quantity
    end
  end
end
