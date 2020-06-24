# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


product1 = Product.create!(name: "Sofa", price: "65000")
prodcut2 = Product.create!(name: "Armchair", price: "28000")

stock1 = Stock.create!(name: "Stock1", address: "Some street 1")
stock2 = Stock.create!(name: "Stock2", address: "Some street 2")

location1 = ProductLocation.create!(product: product1, stock: stock1, quantity: 10)
location2 = ProductLocation.create!(product: product1, stock: stock2, quantity: 5)
location3 = ProductLocation.create!(product: prodcut2, stock: stock2, quantity: 8)

puts "#{stock1.name}, quantity of product1: #{location1.quantity}"
puts "#{stock2.name}, quantity of product1: #{location2.quantity}"

demanded_quantity = 12
puts "Buying #{demanded_quantity} items of #{product1.name}"
Products::Buy.new.call(product_id: product1.id, quantity: 12)

puts "#{stock1.name}, quantity of #{product1.name}: #{location1.reload.quantity}"
puts "#{stock2.name}, quantity of #{product1.name}: #{location2.reload.quantity}"

puts "Transferring item of #{product1.name} from #{stock2.name} to #{stock1.name}"
Products::Transfer.new.call(
  product_id: product1.id,
  current_stock_id: stock2.id,
  new_stock_id: stock1.id,
  quantity: 1
)

puts "#{stock1.name}, quantity of #{product1.name}: #{location1.reload.quantity}"
puts "#{stock2.name}, quantity of #{product1.name}: #{location2.reload.quantity}"

puts "#{stock1.name}, balance: #{stock1.balance}"
puts "#{stock2.name}, balance: #{stock2.balance}"
