require "checkout"
require "bogof_rule"
require "price_discount_rule"
require "percentage_discount_rule"

RSpec.describe Checkout do
  context "create checkout" do
    it "should create a empty checkout" do
      checkout = Checkout.new
      expect(checkout).to be_an_instance_of Checkout
      expect(checkout.items).to  be_empty
      expect(checkout.total).to eq 0
    end

    it "should add items to checkout" do
      product = Product.new("GR1", "Green tea", 3.11)
      checkout = Checkout.new
      checkout.scan(product)

      expect(checkout).to respond_to(:scan).with(1).argument
      expect(checkout.items.first).to be_an_instance_of Product
    end

    it "should create a checkout with empty pricing rules" do
      checkout = Checkout.new

      expect(checkout.pricing_rules).to be_an_instance_of Array
      expect(checkout.pricing_rules).to be_empty
    end

    it "should create a checkout with pricing rules" do
      product = Product.new("GR1", "Green tea", 3.11)
      pricing_rule = PricingRule.new(product)
      pricing_rules = [pricing_rule]
      checkout = Checkout.new(pricing_rules)

      expect(checkout.pricing_rules.first).to be_an_instance_of PricingRule
    end
  end

  context "Calculate total" do
    context "without pricing rules" do
      it "should return zero if it doesn't have items" do
        checkout = Checkout.new

        expect(checkout.pricing_rules).to be_empty
        expect(checkout.items.size).to eq 0
        expect(checkout.total).to eq 0
      end

      it "should calculate the total with one item" do
        product = Product.new("GR1", "Green tea", 3.11)
        checkout = Checkout.new
        checkout.scan(product)

        expect(checkout.pricing_rules).to be_empty
        expect(checkout.items.size).to eq 1
        expect(checkout.total).to eq 3.11
      end

      it "should calculate the total with more items" do
        product_1 = Product.new("GR1", "Green tea", 3.11)
        product_2 = Product.new("CF1", "Coffee", 11.23)
        checkout = Checkout.new
        checkout.scan(product_1)
        checkout.scan(product_2)

        expect(checkout.pricing_rules).to be_empty
        expect(checkout.items.size).to eq 2
        expect(checkout.total).to eq(3.11 + 11.23)
      end
    end

    context "with pricing rules" do
      it "should call calculate total method" do
        product = Product.new("GR1", "Green tea", 3.11)
        pricing_rule = PricingRule.new(product)
        pricing_rules = [pricing_rule]
        checkout = Checkout.new(pricing_rules)

        expect(checkout).to receive(:calculate_total)
        checkout.total
      end

      context "with BOGOF pricing rule" do

        it "should apply with products with the rule and without the rule" do
          product_1 = Product.new("GR1", "Green tea", 3.11)
          product_2 = Product.new("SR1", "Strawberries", 5.00)
          pricing_rule = BogofRule.new(product_1)
          pricing_rules = [pricing_rule]
          checkout = Checkout.new(pricing_rules)
          2.times { checkout.scan(product_1) }
          checkout.scan(product_2)

          expect(checkout.total).to eq 8.11
        end
      end

      context "with price discount pricing rule" do
        it "should apply with products with the rule and without the rule" do
          product_1 = Product.new("SR1", "Strawberries", 5.00)
          product_2 = Product.new("GR1", "Green tea", 3.11)
          pricing_rule = PriceDiscountRule.new(product_1, {min_quantity: 2, new_price: 4.50})
          pricing_rules = [pricing_rule]
          checkout = Checkout.new(pricing_rules)
          2.times { checkout.scan(product_1) }
          checkout.scan(product_2)

          expect(checkout.total).to eq 12.11
        end
      end

      context "with percentage discount pricing rule" do

        it "should apply with products with the rule and without the rule" do
          product_1 = Product.new("CF1", "Coffee", 11.23)
          product_2 = Product.new("GR1", "Green tea", 3.11)
          pricing_rule = PercentageDiscountRule.new(product_1, {min_quantity: 3, percentage: (2.0/3.0)})
          pricing_rules = [pricing_rule]
          checkout = Checkout.new(pricing_rules)
          3.times { checkout.scan(product_1) }
          checkout.scan(product_2)

          expect(checkout.total).to eq 25.57
        end
      end

      context "Mixing products and pricing rules" do
        it "Add to the basket GR1, SR1, GR1, GR1, CF1" do
          product_1 = Product.new("GR1", "Green tea", 3.11)
          product_2 = Product.new("SR1", "Strawberries", 5.00)
          product_3 = Product.new("CF1", "Coffee", 11.23)
          rule_1 = BogofRule.new(product_1)
          rule_2 = PriceDiscountRule.new(product_2, {min_quantity: 3, new_price: 4.50})
          rule_3 = PercentageDiscountRule.new(product_3, {min_quantity: 3, percentage: (2/3)})
          pricing_rules = [rule_1, rule_2, rule_3]
          checkout = Checkout.new(pricing_rules)
          checkout.scan(product_1)
          checkout.scan(product_2)
          checkout.scan(product_1)
          checkout.scan(product_1)
          checkout.scan(product_3)

          expect(checkout.total).to eq 22.45
        end

        it "Add to the basket GR1, GR1" do
          product_1 = Product.new("GR1", "Green tea", 3.11)
          rule_1 = BogofRule.new(product_1)
          pricing_rules = [rule_1]
          checkout = Checkout.new(pricing_rules)
          checkout.scan(product_1)
          checkout.scan(product_1)

          expect(checkout.total).to eq 3.11
        end

        it "Add to the basket SR1, SR1, GR1, SR1" do
          product_1 = Product.new("GR1", "Green tea", 3.11)
          product_2 = Product.new("SR1", "Strawberries", 5.00)
          rule_1 = BogofRule.new(product_1)
          rule_2 = PriceDiscountRule.new(product_2, {min_quantity: 3, new_price: 4.50})
          pricing_rules = [rule_1, rule_2]
          checkout = Checkout.new(pricing_rules)
          checkout.scan(product_2)
          checkout.scan(product_2)
          checkout.scan(product_1)
          checkout.scan(product_2)

          expect(checkout.total).to eq 16.61
        end

        it "Add to the basket GR1, CF1, SR1, CF1, CF1" do
          product_1 = Product.new("GR1", "Green tea", 3.11)
          product_2 = Product.new("SR1", "Strawberries", 5.00)
          product_3 = Product.new("CF1", "Coffee", 11.23)
          rule_1 = BogofRule.new(product_1)
          rule_2 = PriceDiscountRule.new(product_2, {min_quantity: 3, new_price: 4.50})
          rule_3 = PercentageDiscountRule.new(product_3, {min_quantity: 3, percentage: (2.0/3.0)})
          pricing_rules = [rule_1, rule_2, rule_3]
          checkout = Checkout.new(pricing_rules)
          checkout.scan(product_1)
          checkout.scan(product_3)
          checkout.scan(product_2)
          checkout.scan(product_3)
          checkout.scan(product_3)

          expect(checkout.total).to eq 30.57
        end
      end
    end
  end
end
