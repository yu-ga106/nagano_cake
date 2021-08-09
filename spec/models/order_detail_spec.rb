require 'rails_helper'

RSpec.describe OrderDetail, type: :model do
  describe '注文商品のバリデーションテスト' do
    let(:order) do
      Order.create(
        id: 1,
        shipping_cost: 800,
        payment_method: 1,
        total_payment: 2000,
        status: 3,
        name: '田中',
        address: '東京都千代田区',
        postal_code: '1111111'
      )
    end
    let(:item) { Item.create(id: 1, name: 'いちごのケーキ', introduction: '美味しいケーキです', price: 400) }
    let(:order_detail) { OrderDetail.create(amount: 1, making_status: 3, price: 400, item: item, order: order) }

    it 'バリデーションが有効なこと' do
      expect(order_detail).to be_valid
    end

    it '購入価格が空欄でないこと' do
      order_detail.price = ''
      expect(order_detail).to be_invalid
    end

    it '数量が空欄でないこと' do
      order_detail.amount = ''
      expect(order_detail).to be_invalid
    end

    it '製造ステータスが空欄でないこと' do
      order_detail.making_status = ''
      expect(order_detail).to be_invalid
    end
  end
end