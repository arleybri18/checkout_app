require "pricing_rule"

RSpec.describe PricingRule do
  context "pricing rules" do
    it "should create a new pricing rule for a product" do
      product = Product.new("GR1", "Green tea", 3.11)
      pricing_rule = PricingRule.new(product)

      expect(pricing_rule).to be_an_instance_of PricingRule
      expect(pricing_rule.product).to  be_an_instance_of Product
    end

    it "should return not implemented method error" do
      product = Product.new("GR1", "Green tea", 3.11)
      pricing_rule = PricingRule.new(product)

      expect { pricing_rule.calculate_total(1) }.to raise_error(NotImplementedError, "Cannot calculate total, please implement the logic")
    end
  end
end
