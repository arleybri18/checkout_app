# frozen_string_literal: true

# This class inherit from PricingRule class, implement the calculation method to allow apply
# Buy One Get One Free (BOGOF) discount to a product based in the quantity
#
require_relative "pricing_rule"

class BogofRule < PricingRule

  # This method takes the quantity of the product and validate to aply the discount
  # If the quantity is even it will take the half of the quantity
  # else it will take the the half of the quantity plus one more
  # it will calculate the final_quantity for the product and the product.price stored
  #
  # ==== Attributes
  #
  # * +quantity+ - quantity of the product
  #
  def calculate_total(quantity)
    final_quantity = quantity.even? ? (quantity / 2) : ((quantity / 2) + 1)
    product.price * final_quantity
  end
end
