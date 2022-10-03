# frozen_string_literal: true

# This is an interface for Pricing rules, intialize with a +product+ and a +options+ hash,
# this options will be used in the calculate_method implementation.
# If you want to add a new rule create a new class that inherited from PicingRule and
# implement the calculate_total method.
#
class PricingRule
  attr_accessor :product, :options

  def initialize(product, options = {})
    @product = product
    @options = options
  end

  # This method takes the quantity of the product, use the product and options
  # information and; returns the total price for it
  #
  # ==== Attributes
  #
  # * +quantity+ - quantity of the product
  #
  def calculate_total(quantity)
    raise NotImplementedError, "Cannot calculate total, please implement the logic"
  end
end
