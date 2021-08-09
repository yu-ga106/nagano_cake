require 'rails_helper'

RSpec.describe Item, type: :model do
  describe '商品のバリデーション' do
    let!(:genre) { Genre.new(id: 1, name: 'ケーキ') }
    let!(:item) { genre.items.build(genre_id: 1, name: 'いちごのケーキ', introduction: '美味しいケーキです', price: 400) }

    it 'バリデーションが有効であること' do
      expect(item).to be_valid
    end

    it '値段が空欄でないこと' do
      item.price = ''
      expect(item).to be_invalid
    end

    context '商品名のバリデーション' do
      it '空欄でないこと' do
        item.name = ''
        expect(item).to be_invalid
      end

      it '50文字以内であること' do
        item.name = "a" * 51
        expect(item).to be_invalid
      end
    end

    context '商品説明のバリデーション' do
      it '空欄でないこと' do
        item.introduction = ''
        expect(item).to be_invalid
      end

      it '300文字以内であること' do
        item.introduction = "a" * 301
        expect(item).to be_invalid
      end
    end
  end
end