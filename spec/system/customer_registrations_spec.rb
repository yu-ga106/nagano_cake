require 'rails_helper'

RSpec.describe "登録〜発送", type: :system do
  let(:customer) { create(:customer_test) }
  # FactoryBotを持ってきてくれる

  # 税込の計算
  def tax_price(price)
    (price * 1.1).floor
  end

  # 小計の計算
  def sub_price(sub)
    (tax_price(sub.item.price) * sub.amount)
  end

  # 合計金額の計算
  def total_payment(totals)
    price = 0
    totals.each do |total|
      price += sub_price(total)
    end
    price
  end

  # 請求額の計算
  def billing(order)
    total_payment(customer.cart_items) + @order.shipping_cost.to_i
  end

  context 'トップページ' do
    it '新規登録画面が表示されること' do
      visit root_path
      click_link '新規登録'
      expect(current_path).to eq new_customer_registration_path
    end
  end

  context '新規登録画面' do
    it 'マイページに遷移' do
      visit new_customer_registration_path
      fill_in 'customer_last_name', with: customer.last_name
      fill_in 'customer_first_name', with: customer.first_name
      fill_in 'customer_last_name_kana', with: customer.last_name_kana
      fill_in 'customer_first_name_kana', with: customer.first_name_kana
      fill_in 'customer_email', with: customer.email
      fill_in 'customer_password', with: customer.password
      fill_in 'customer_postal_code', with: customer.postal_code
      fill_in 'customer_address', with: customer.address
      click_button '登録'
      expect(current_path).to eq customers_path
    end

    it 'ユニークでないメールアドレスのバリデーション' do
      visit new_customer_registration_path
      fill_in 'customer_last_name', with: customer.last_name
      fill_in 'customer_first_name', with: customer.first_name
      fill_in 'customer_last_name_kana', with: customer.last_name_kana
      fill_in 'customer_first_name_kana', with: customer.first_name_kana
      fill_in 'customer_email', with: customer.email
      fill_in 'customer_password', with: customer.password
      fill_in 'customer_postal_code', with: customer.postal_code
      fill_in 'customer_address', with: customer.address
      click_button '登録'
      expect(page).to have_content('メールアドレスはすでに存在します')
    end
  end

  describe '新規登録後' do
    before do
      # visit admin_genres_path
      # fill_in 'genre_name', with: 'ケーキ'
      # click_on '新規追加'
      @genre = Genre.create(id: 1, name: 'ケーキ')
      @item = Item.create(
        id: 1,
        genre_id: 1,
        name: '絵のケーキ',
        introduction: 'ケーキ',
        price: 400,
        is_active: true,
        image_id: 1
      )
      @cart_items = CartItem.create(
        id: 1,
        customer_id: customer.id,
        item_id: @item.id,
        amount: 2
      )
      @order = customer.orders.create(
        id: 1,
        customer_id: 1,
        address: '東京都　新宿　2丁目',
        total_payment: 880,
        payment_method: 0,
        name: '田中太郎',
        postal_code: '0000000',
        shipping_cost: 800,
        status: 0,
      )
      @order_detail = OrderDetail.create(
        id: 1,
        item_id: 1,
        order_id: 1,
        amount: 2,
        making_status: 0,
        price: 1660
      )

      visit new_customer_session_path
      fill_in 'customer_email', with: customer.email
      fill_in 'customer_password', with: customer.password
      click_button 'ログイン'
      visit customers_path
    end

    it '新規登録後登録情報の表示' do
      expect(page).to have_content(customer.last_name)
      expect(page).to have_content(customer.first_name)
      expect(page).to have_content(customer.last_name_kana)
      expect(page).to have_content(customer.last_name_kana)
      expect(page).to have_content(customer.email)
      expect(page).to have_content(customer.postal_code)
      expect(page).to have_content(customer.address)
    end

    it 'ヘッダーの表示' do
      expect(page).not_to have_content('新規登録')
    end

    it '店名でトップ画面へ遷移' do
      click_link 'NaganoCAKE'
      expect(current_path).to eq root_path
    end

    context '商品画面' do
      it '該当商品の詳細ページへの遷移' do
        visit root_path
        find('.row > .col-3 > a').click
        # expect(page).to have_content(@item.name)
        expect(current_path).to eq item_path(@item)
      end

      def tax_price(price)
        (price * 1.1).floor
      end

      it '商品詳細ページ　商品情報の表示' do
        visit item_path(@item)
        expect(page).to have_content(@item.name)
        expect(page).to have_content(@item.introduction)
        expect(page).to have_content(tax_price(@item.price))
        expect(page).to have_content('販売中')
      end
    end

    context 'カート画面' do
      before do
        visit item_path(@item)
        select '1', from: 'amount'
        click_on 'カートに入れる'
      end

      it 'カート画面に遷移' do
        expect(current_path).to eq cart_items_path
      end

      it 'カートの中身が正しく表示されている' do
        expect(page).to have_content(@item.name)
        expect(page).to have_content(tax_price(@cart_items.item.price))
        expect(page).to have_content(@cart_items.amount)
        expect(page).to have_content(@item.name)
      end

      it '合計表示が正しく更新される' do
        select '2', from: 'cart_item_amount'
        click_button '変更'
        expect(page).to have_content(@cart_items.amount * 2)
      end

      it '情報入力画面へ遷移' do
        click_on '情報入力に進む'
        expect(current_path).to eq new_order_path
      end
    end

    context '注文情報入力画面' do
      before do
        visit new_order_path
      end

      it '支払い方法を選択する' do
        choose 'order_payment_method_銀行振込'
      end

      it '住所をテキスト入力する' do
        choose 'order_address_selection_new_address'
        fill_in 'order_postal_code', with: '0000000'
        fill_in 'order_address', with: '東京都渋谷区'
        fill_in 'order_name', with: '田中太郎'
      end

      it '注文確認画面へ遷移' do
        click_button '確認画面へ進む'
        expect(current_path).to eq log_orders_path
      end
    end

    context '注文確認画面' do
      before do
        visit new_order_path
        choose 'order_payment_method_銀行振込'
        choose 'order_address_selection_new_address'
        fill_in 'order_postal_code', with: '0000000'
        fill_in 'order_address', with: '東京都渋谷区'
        fill_in 'order_name', with: '田中太郎'
        click_button '確認画面へ進む'
        visit log_orders_path
      end

      it '選択した商品、合計金額、配送方法などが表示されている' do
        expect(page).to have_content(@item.name)
        expect(page).to have_content(@order.payment_method.to_i)
        expect(page).to have_content('東京都渋谷区')
        expect(page).to have_content(total_payment(customer.cart_items))
      end
    end

    context 'サンクスページ' do
      before do
        visit new_order_path
        choose 'order_payment_method_銀行振込'
        choose 'order_address_selection_new_address'
        fill_in 'order_postal_code', with: '0000000'
        fill_in 'order_address', with: '東京都渋谷区'
        fill_in 'order_name', with: '田中太郎'
        click_button '確認画面へ進む'
        click_on '注文を確定する'
      end

      it 'サンクスページへ遷移' do
        expect(current_path).to eq thanks_orders_path
      end

      it '注文履歴一覧画面の表示' do
        # visit thanks_orders_path
        click_link '注文履歴はこちら'
        expect(current_path).to eq orders_path
      end
    end

    context '注文履歴詳細画面' do
      it '注文詳細画面へ遷移' do
        visit orders_path
        click_on '注文詳細'
        expect(current_path).to eq order_path(@order)
      end

      it '注文詳細の表示' do
        visit order_path(@order)
        expect(page).to have_content(@order.address)
        expect(page).to have_content(@order.payment_method.to_i)
        expect(page).to have_content(@order.status.to_i)
        expect(page).to have_content(billing(customer))
        expect(page).to have_content(@item.name)
        expect(page).to have_content(@order_detail.amount)
      end

      it 'ステータスが入金待ち' do
        visit order_path(@order)
        expect(page).to have_content('入金待ち')
      end
    end
  end
end