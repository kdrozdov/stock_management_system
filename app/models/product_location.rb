class ProductLocation < ApplicationRecord
  belongs_to :product
  belongs_to :stock

  validates :product, uniqueness: { scope: :stock }
end
