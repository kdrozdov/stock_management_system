class Stock < ApplicationRecord
  has_many :product_shipments

  def balance
    # This result will be cached
    product_shipments.sum(:amount)
  end
end
