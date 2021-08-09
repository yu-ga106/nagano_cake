require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'カスタマーバリデーションのテスト' do
    let!(:customer_test) { FactoryBot.build(:customer_test) }

    it 'バリデーションが有効なこと' do
      expect(customer_test).to be_valid
    end

    it 'メールアドレスが空欄でないこと' do
      customer_test.email = ''
      expect(customer_test).to be_invalid
    end

    context '名前のバリデーション' do
      it '姓が空欄でないこと' do
        customer_test.last_name = ''
        expect(customer_test).to be_invalid
      end

      it '名が空欄でないこと' do
        customer_test.first_name = ''
        expect(customer_test).to be_invalid
      end

      it '姓カナが空欄でないこと' do
        customer_test.last_name_kana = ''
        expect(customer_test).to be_invalid
      end

      it '名カナが空欄でないこと' do
        customer_test.first_name_kana = ''
        expect(customer_test).to be_invalid
      end
    end

    context 'パスワードのバリデーション' do
      it 'パスワードが5文字以下でないこと' do
        customer_test.password = '12345'
        expect(customer_test).to be_invalid
      end

      it 'パスワードが6文字以上であること' do
        customer_test.password = '123456'
        expect(customer_test).to be_valid
      end
    end

    it '郵便番号が空でないこと' do
      customer_test.postal_code = ''
      expect(customer_test).to be_invalid
    end

    it '住所が空でないこと' do
      customer_test.address = ''
      expect(customer_test).to be_invalid
    end

    it '電話番号が空でないこと' do
      customer_test.telephone_number = ''
      expect(customer_test).to be_invalid
    end
  end
end