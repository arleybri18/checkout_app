require "bogof_rule"

RSpec.describe BogofRule do
  context "with BOGOF pricing rule" do
    it "should apply with two products" do
      product = Product.new("GR1", "Green tea", 3.11)
      pricing_rule = BogofRule.new(product)

      expect(pricing_rule.calculate_total(2)).to eq 3.11
    end

    it "should apply with five products" do
      product = Product.new("GR1", "Green tea", 3.11)
      pricing_rule = BogofRule.new(product)

      expect(pricing_rule.calculate_total(5)).to eq 9.33
    end

  end
end
