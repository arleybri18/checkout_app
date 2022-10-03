require "product"

RSpec.describe Product do
  context "Create products" do
    it "should create a new product" do
      product = Product.new("GR1", "Green tea", 3.11)

      expect(product).to be_an_instance_of Product
      expect(product.code).to eq "GR1"
      expect(product.name).to eq "Green tea"
      expect(product.price).to eq 3.11
    end

    it "should allow to create a new product with string price" do
      product = Product.new("GR1", "Green tea", "3.11")

      expect(product.price).to eq 3.11
    end

    it "should to put zero value is price is a word" do
      product = Product.new("GR1", "Green tea", "value")

      expect(product.price).to eq 0.0
    end
  end
end
