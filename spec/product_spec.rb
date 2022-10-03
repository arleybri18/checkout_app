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
  end
end
