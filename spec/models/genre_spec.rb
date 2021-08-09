require 'rails_helper'

RSpec.describe Genre, type: :model do
  describe 'ジャンルのバリデーションテスト' do
    it 'ジャンル名が空欄ではないこと' do
      genre = Genre.new(name: '')
      expect(genre).to be_invalid
    end
  end
end