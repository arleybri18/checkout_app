# frozen_string_literal: true

##
# This class represents a product.
class Product
  attr_accessor :code, :name, :price
  ##
  # Creates a new shape described by a +polyline+.
  #
  # If the +polyline+ does not end at the same point it started at the
  # first pointed is copied and placed at the end of the line.
  def initialize(code, name, price)
    @code = code
    @name = name
    @price = price&.to_f
  end
end
