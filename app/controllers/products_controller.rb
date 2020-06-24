class ProductsController < ApplicationController
  before_action { set_safe_params }

  schema(:transfer) do
    required(:product_id).value(:integer)
    required(:current_stock_id).value(:integer)
    required(:new_stock_id).value(:integer)
    optional(:quantity).value(:integer)
  end

  def transfer
    operation_result = resolve('products.transfer').(safe_params.to_h)
    if operation_result.success?
      render json: { status: :ok }
    else
      render json: { status: :error, message: operation_result.failure[:message] },
        status: :unprocessable_entity
    end
  end

  schema(:buy) do
    required(:product_id).value(:integer)
    required(:quantity).value(:integer)
  end

  def buy
    operation_result = resolve('products.buy').(safe_params.to_h)
    if operation_result.success?
      render json: { status: :ok }
    else
      render json: { status: :error, message: operation_result.failure[:message] },
        status: :unprocessable_entity
    end
  end
end
