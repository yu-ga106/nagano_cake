FactoryBot.define do
  factory :customer do
  end

  factory :customer_test, class: 'Customer' do
    id { 1 }
    email { 'tes@example.com' }
    password { 'password' }
    last_name { '田中' }
    first_name { '太郎' }
    last_name_kana { 'タナカ' }
    first_name_kana { 'タロウ' }
    postal_code { '1111111' }
    address { '東京都　新宿　2丁目' }
    telephone_number { '1234567' }
    is_deleted { false }
  end

  factory :genre, class: 'Genre' do
    id { 1 }
    name { 'ケーキ' }
  end

  factory :item, class: 'Item' do
    id { 1 }
    genre_id { 1 }
    name { '絵のケーキ' }
    introduction { 'ケーキ' }
    price { 400 }
    is_active { true }
    image_id { 'image.jpg' }
  end
end