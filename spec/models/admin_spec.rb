require 'rails_helper'

RSpec.describe Admin, type: :model do
  describe '管理者バリデーションテスト' do
    let(:admin) { FactoryBot.build(:admin) }

    it 'バリデーションが有効なこと' do
      expect(admin).to be_valid
    end

    it 'メールアドレスが空欄でないこと' do
      admin.email = ''
      expect(admin).to be_invalid
    end

    context 'パスワードが6文字以上であること' do
      it 'パスワードが5文字' do
        admin.password = '12345'
        expect(admin).to be_invalid
      end

      it 'パスワードが6文字' do
        admin.password = '123456'
        expect(admin).to be_valid
      end
    end
  end
end
