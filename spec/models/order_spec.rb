require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '注文のバリデーションテスト' do
    let!(:customer) { Customer.create(id: 1) }
    let!(:order) do
      customer.orders.build(
        customer_id: 1,
        shipping_cost: 800,
        payment_method: 1,
        total_payment: 2000,
        status: 3,
        name: '田中',
        address: '東京都千代田区',
        postal_code: '1111111'
      )
    end

    it 'バリデーションが有効であること' do
      expect(order).to be_valid
    end

    it '配送料が空欄ではないこと' do
      order.shipping_cost = ''
      expect(order).to be_invalid
    end

    it '支払い方法が選択されていること' do
      order.payment_method = ''
      expect(order).to be_invalid
    end

    it '注文ステータスが選択されていること' do
      order.status = ''
      expect(order).to be_invalid
    end

    it '配送先宛名が空欄でないこと' do
      order.name = ''
      expect(order).to be_invalid
    end

    it '住所が空欄でないこと' do
      order.address = ''
      expect(order).to be_invalid
    end

    context '郵便番号が7文字であること' do
      it '7文字以外' do
        order.postal_code = '123456'
        expect(order).to be_invalid
        order.postal_code = '12345678'
        expect(order).to be_invalid
      end

      it '7文字' do
        order.postal_code = '1234567'
        expect(order).to be_valid
      end
    end
  end
end