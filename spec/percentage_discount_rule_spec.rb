require "percentage_discount_rule"

RSpec.describe PercentageDiscountRule do
  context "with percentage discount pricing rule" do
    it "should apply with three products" do
      product_1 = Product.new("CF1", "Coffee", 11.23)
      pricing_rule = PercentageDiscountRule.new(product_1, {min_quantity: 3, percentage: (2.0/3.0)})

      expect(pricing_rule.calculate_total(3)).to eq 22.46
    end
  end
end
