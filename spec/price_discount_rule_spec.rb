require "price_discount_rule"

RSpec.describe PriceDiscountRule do
  context "with price discount pricing rule" do
    it "should apply with three products" do
      product_1 = Product.new("SR1", "Strawberries", 5.00)
      pricing_rule = PriceDiscountRule.new(product_1, {min_quantity: 3, new_price: 4.50})

      expect(pricing_rule.calculate_total(3)).to eq 13.50
    end
  end
end
