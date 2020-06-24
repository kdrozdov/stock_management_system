require 'rails_helper'

RSpec.describe Products::Buy do
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

  subject do
    described_class.new.call(
      product_id: product.id,
      quantity: demanded_quantity
    )
  end

  context 'when there is enough quantity of products' do
    it 'updates quantity in stock' do
      subject
      locations.map(&:reload)
      expect(locations.first.quantity).to eq(0)
      expect(locations.second.quantity).to eq(3)
    end

    it 'creates product shipments' do
      subject
      shipment1 = ProductShipment.find_by(product_id: product.id, stock_id: stock1.id)
      expect(shipment1).not_to be_nil
      expect(shipment1.amount).to eq(product.total_price(10))

      shipment2 = ProductShipment.find_by(product_id: product.id, stock_id: stock2.id)
      expect(shipment2).not_to be_nil
      expect(shipment2.amount).to eq(product.total_price(2))
    end
  end

  context 'when there is not enough quantity of products' do
    let(:demanded_quantity) { 20 }

    it 'returns failure' do
      expect(subject.success?).to eq(false)
    end
  end
end
