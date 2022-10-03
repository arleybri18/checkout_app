
# Checkout Implementation

This is a ruby implementation that allows to create a checkout and calculate a final price, the checkout takes in account products in a basket and pricing rules defined by the users.




## Installation

Download the project and run ```bundle install``` inside the project folder.
You can use this app from irb console, run the following commands

```bash
  irb
  require_relative "lib/checkout"
```

or, you can add to your project and require the rb files from lib directory.

```ruby
    require_relative "../lib/product"
    require_relative "../lib/checkout"
    require_relative "../lib/pricing_rule"
    require_relative "../lib/bogof_rule"
    require_relative "../lib/percentage_discount_rule"
    require_relative "../lib/price_discount_rule"
```

## Usage/Examples

For use, you have two options

* From IRB or code, using the available classes:
```ruby
# create products
product_1 = Product.new("GR1", "Green tea", 3.11)
product_2 = Product.new("SR1", "Strawberries", 5.00)
product_3 = Product.new("CF1", "Coffee", 11.23)

# create rules
rule_1 = BogofRule.new(product_1)
rule_2 = PriceDiscountRule.new(product_2, {min_quantity: 3, new_price: 4.50})
rule_3 = PercentageDiscountRule.new(product_3, {min_quantity: 3, percentage: (2/3)})
pricing_rules = [rule_1, rule_2, rule_3]

# create checkout and scan products
checkout = Checkout.new(pricing_rules)
checkout.scan(product_1)
checkout.scan(product_2)

# get the total
checkout.total
```

* Using a little interface from main.rb file, run the following commands

```bash
chmod u+x ./bin/main.rb
./bin/main.rb
```

You will see a interface like this:
```bash
----------------------------------- WELCOME TO CHECKOUT APP -----------------------------------
1. Create products.
2. Create pricing rule.
3. Create checkout.
4. exit.
------------------------------------------------------------------------------------------
```
## Running Tests

To run tests, run the following command

```bash
  bin/rspec --format doc
```


## Authors

- [@arleybri18](https://github.com/arleybri18)

