require 'rails_helper'

RSpec.describe Products::Transfer do
  let(:product) { Product.create!(name: "Диван", price: "65000") }
  let(:stock1) { Stock.create!(name: "Склад 1", address: "ул. Советская 1") }
  let(:stock2) { Stock.create!(name: "Склад 2", address: "ул. Ленина 1") }
  let!(:current_location) do
    ProductLocation.create!(product: product, stock: stock1, quantity: 10)
  end
  let(:quantity_to_transfer) { 5 }

  subject do
    described_class.new.call(
      product_id: product.id,
      current_stock_id: stock1.id,
      new_stock_id: stock2.id,
      quantity: quantity_to_transfer
    )
  end

  context 'when product exists in the destination stock' do
    let!(:new_location) do
      ProductLocation.create!(product: product, stock: stock2, quantity: 5)
    end

    it 'transfers products from one stock to another' do
      subject
      new_location.reload
      expect(new_location.quantity).to eq(quantity_to_transfer + 5)
    end
  end

  context 'when product does not exist in the destination stock' do
    it 'transfers products from one stock to another' do
      subject
      new_location = ProductLocation.find_by(stock_id: stock2.id, product_id: product.id)
      expect(new_location.quantity).to eq(quantity_to_transfer)
    end
  end

  context 'when quantity is not provided' do
    let!(:new_location) do
      ProductLocation.create!(product: product, stock: stock2, quantity: 5)
    end
    let(:quantity_to_transfer) { nil }

    it 'transfers all products from one stock to another' do
      subject
      new_location.reload
      expect(new_location.quantity).to eq(current_location.quantity + 5)
    end

    # it 'removes current location' do
    #   subject
    #   current_location = ProductLocation.find_by(stock_id: stock1.id, product_id: product.id)
    #   expect(current_location).to be_nil
    # end
  end

  context 'when there is not enough quantity of products' do
    let!(:new_location) do
      ProductLocation.create!(product: product, stock: stock2, quantity: 5)
    end
    let!(:quantity_to_transfer) { current_location.quantity + 1 }

    it 'returns failure' do
      expect(subject.success?).to eq(false)
    end
  end
end
