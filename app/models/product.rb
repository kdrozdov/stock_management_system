class Product < ApplicationRecord
  has_many :product_location

  def total_price(quantity)
    price * quantity
  end
end
