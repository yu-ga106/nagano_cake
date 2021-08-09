require 'rails_helper'

RSpec.describe Address, type: :model do
  describe '配送先のバリデーションテスト' do
    let!(:customer_test) { FactoryBot.build(:customer_test) }
    let!(:address) do
      customer_test.addresses.build(
        customer_id: 1, name: '山田太郎', postal_code: '1111111', address: '東京都千代田区'
      )
    end

    it '名前が空欄でないこと' do
      address.name = ''
      expect(address).to be_invalid
    end

    it '住所が空欄でないこと' do
      address.address = ''
      expect(address).to be_invalid
    end

    it '郵便番号が空欄でないこと' do
      address.postal_code = ''
      expect(address).to be_invalid
    end

    context '7文字であること' do
      it '7文字以外' do
        address.postal_code = '123456'
        expect(address).to be_invalid
        address.postal_code = '12345678'
        expect(address).to be_invalid
      end

      it '7文字' do
        address.postal_code = '1234567'
        expect(address).to be_valid
      end
    end
  end
end