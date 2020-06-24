module Products
  class Transfer < ApplicationOperation
    INVALID_QUANTITY_ERROR = "can't trasfer a givent quantity of products"

    def call(product_id:, current_stock_id:, new_stock_id:, quantity: nil)
      ProductLocation.transaction do
        current_location = find_location!(product_id, current_stock_id)

        quantity = current_location.quantity unless quantity.present?
        validate_quantity!(quantity, current_location.quantity)

        new_location = find_or_create_location(product_id, new_stock_id)
        transfer(current_location, new_location, quantity)

        new_location.save!
        current_location.save!
        # current_location.quantity.zero? ? current_location.destroy! : current_location.save!
      end

      Success()
    rescue => e
      Failure(message: e.message)
    end

    private

    def find_location!(product_id, stock_id)
      ProductLocation.lock.find_by!(product_id: product_id, stock_id: stock_id)
    end

    def find_or_create_location(product_id, stock_id)
      product_location = ProductLocation.lock.find_by(
        product_id: product_id,
        stock_id: stock_id
      )
      return product_location unless product_location.blank?

      ProductLocation.create!(product_id: product_id, stock_id: stock_id).lock!
    rescue ActiveRecord::RecordNotUnique
      retry
    end

    def validate_quantity!(quantity, current_quantity)
      unless valid_quantity?(quantity, current_quantity)
        raise StandardError, INVALID_QUANTITY_ERROR
      end
    end

    def valid_quantity?(quantity, current_quantity)
      return false if quantity < 0
      current_quantity >= quantity
    end

    def transfer(current_location, new_location, quantity)
      current_location.quantity -= quantity
      new_location.quantity += quantity
    end
  end
end
