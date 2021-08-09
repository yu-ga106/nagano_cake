Customer.create!(
              last_name: "田中",
              first_name: "太郎",
              last_name_kana: "タナカ",
              first_name_kana: "タロウ",
              telephone_number: "11111111111",
              email: "tes@example.com",
              password: "password",
              postal_code: "1020082",
              address: "新宿",
              is_deleted: false,
              )

  Admin.create!(
              email: "admin@example.com",
              password: "password",
                )

Genre.create!(name: "ケーキ")
Genre.create!(name: "プリン")
Genre.create!(name: "焼き菓子")
Genre.create!(name: "キャンディ")

  2.times{|num|
  Item.create!(
              genre_id: 1,
              #image_id: atattch.open("#{Rails.root}/db/fixtures/img1.jpg"),
              name: "絵のケーキ",
              introduction: "絵に書いたようなイチゴのケーキ",
              price: "400",
              is_active: true,
              )
  Item.create!(
              genre_id: 1,
              # image_id: open("./app/assets/images/パンダ.jpg"),
              name: "パンダケーキ",
              introduction: "白黒のパンダケーキ",
              price: "350",
              is_active: true,
              )
  Item.create!(
              genre_id: 1,
              # image_id: open("./app/assets/images/チーズケーキ.jpg"),
              name: "チーズケーキ",
              introduction: "一番うまいチーズケーキ",
              price: "600",
              is_active: true,
              )
  Item.create!(
              genre_id: 1,
              # image_id: open("./app/assets/images/チーズケーキ.jpg"),
              name: "モンブラン",
              introduction: "クリの風味たっぷり",
              price: "450",
              is_active: true,
              )
  Item.create!(
              genre_id: 2,
              # image_id: open("./app/assets/images/モンブラン.jpg"),
              name: "プリン",
              introduction: "王道のプリン",
              price: "400",
              is_active: true,
              )
  Item.create!(
              genre_id: 2,
              # image_id: open("./app/assets/images/ミルクレープ.jpg"),
              name: "焼きプリン",
              introduction: "表面を焦がし美味しく仕上げました",
              price: "300",
              is_active: true,
              )
  Item.create!(
              genre_id: 2,
              # image_id: open("./app/assets/images/ミルクレープ.jpg"),
              name: "とろけるプリン",
              introduction: "生クリームをふんだんに使用した贅沢プリン",
              price: "450",
              is_active: true,
              )
  Item.create!(
              genre_id: 3,
              # image_id: open("./app/assets/images/ミルクレープ.jpg"),
              name: "長野マフィン",
              introduction: "リーズナブルな価格でお子様に人気です",
              price: "150",
              is_active: true,
              )
  Item.create!(
              genre_id: 3,
              # image_id: open("./app/assets/images/ミルクレープ.jpg"),
              name: "豆乳クッキー",
              introduction: "ヘルシーでダイエット中でもおすすめです",
              price: "350",
              is_active: true,
              )
  Item.create!(
              genre_id: 3,
              # image_id: open("./app/assets/images/ミルクレープ.jpg"),
              name: "フロランタン",
              introduction: "4種類のナッツを使ったフロランタン",
              price: "350",
              is_active: true,
              )
  Item.create!(
              genre_id: 4,
              # image_id: open("./app/assets/images/ミルクレープ.jpg"),
              name: "ペロキャン",
              introduction: "漫画のようなペロペロキャンディ",
              price: "200",
              is_active: true,
              )
  Item.create!(
              genre_id: 4,
              # image_id: open("./app/assets/images/ミルクレープ.jpg"),
              name: "ポップキャンディ",
              introduction: "おしゃれなキャンディ",
              price: "400",
              is_active: true,
              )
  Item.create!(
              genre_id: 4,
              # image_id: open("./app/assets/images/ミルクレープ.jpg"),
              name: "コロコロキャンディ",
              introduction: "コロコロかわいいキャンディ",
              price: "500",
              is_active: true,
              )
  Item.create!(
              genre_id: 4,
              # image_id: open("./app/assets/images/ミルクレープ.jpg"),
              name: "サクマドロップス",
              introduction: "なつかしい味のするキャンディ",
              price: "1000",
              is_active: true,
              )

  }