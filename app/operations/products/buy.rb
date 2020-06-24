module Products
  class Buy < ApplicationOperation
    INVALID_QUANTITY_ERROR = "can't reserve a givent quantity of products"

    def call(product_id:, quantity:)
      product = Product.find(product_id)

      ProductLocation.transaction do
        locations = find_product_locations(product_id)

        total_quantity = locations.sum(&:quantity)
        validate_quantity!(quantity, total_quantity)

        create_product_shipments(locations, product, quantity)
      end

      Success()
    rescue => e
      Failure(message: e.message)
    end

    private

    def create_product_shipments(locations, product, quantity)
      demanded_quantity = quantity

      locations.each do |location|
        shipment_quantity = [location.quantity, demanded_quantity].min
        location.quantity -= shipment_quantity
        demanded_quantity -= shipment_quantity

        ProductShipment.create!(
          quantity: shipment_quantity,
          amount: product.total_price(shipment_quantity),
          product: product,
          stock_id: location.stock_id
        )

        location.save!
        # location.quantity.zero? ? location.destroy! : location.save!
        break if demanded_quantity.zero?
      end
    end

    def find_product_locations(product_id)
      ProductLocation.lock.where(product_id: product_id)
    end

    def validate_quantity!(quantity, total_quantity)
      unless valid_quantity?(quantity, total_quantity)
        raise StandardError, INVALID_QUANTITY_ERROR
      end
    end

    def valid_quantity?(quantity, total_quantity)
      return false if quantity < 0
      total_quantity >= quantity
    end
  end
end
