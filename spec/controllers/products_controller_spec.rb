require 'rails_helper'

RSpec.describe ProductsController do
  describe "POST transfer" do
    subject { post :transfer, params: params }

    let(:product) { Product.create!(name: "Диван", price: "65000") }
    let(:stock1) { Stock.create!(name: "Склад 1", address: "ул. Советская 1") }
    let(:stock2) { Stock.create!(name: "Склад 2", address: "ул. Ленина 1") }
    let!(:current_location) do
      ProductLocation.create!(product: product, stock: stock1, quantity: 10)
    end
    let(:quantity_to_transfer) { 5 }

    let(:params) do
      {
        product_id: product.id,
        current_stock_id: stock1.id,
        new_stock_id: stock2.id,
        quantity: quantity_to_transfer
      }
    end

    it 'returns 200' do
      subject
      expect(response.status).to eq(200)
    end
  end

  describe "POST buy" do
    subject { post :buy, params: params }

    let!(:product) { Product.create!(name: "Диван", price: "65000") }
    let!(:stock1) { Stock.create!(name: "Склад 1", address: "ул. Советская 1") }
    let!(:stock2) { Stock.create!(name: "Склад 2", address: "ул. Ленина 1") }
    let!(:locations) do
      [
        ProductLocation.create!(product: product, stock: stock1, quantity: 10),
        ProductLocation.create!(product: product, stock: stock2, quantity: 5)
      ]
    end
    let(:demanded_quantity) { 12 }

    let(:params) do
      {
        product_id: product.id,
        quantity: demanded_quantity
      }
    end

    it 'returns 200' do
      subject
      expect(response.status).to eq(200)
    end
  end
end

