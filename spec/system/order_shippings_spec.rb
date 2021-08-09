require 'rails_helper'
RSpec.describe "制作～発送", type: :system do
  admin = Admin.create(email: 'admin@example.com', password: 'password')
  let!(:customer) do
    Customer.create(
      id: 1,
      email: 'test@example.com',
      password: 'password',
      last_name: '鈴木',
      first_name: '次郎',
      last_name_kana: 'すずき',
      first_name_kana: 'じろう',
      postal_code: '1234567',
      telephone_number: '12345678912',
      address: '渋谷',
    )
  end
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

  context 'ログイン画面' do
    it 'ヘッダーから遷移' do
      visit root_path
      click_link '管理者ログイン'
      expect(current_path).to eq new_admin_session_path
    end
    it 'ログイン画面が表示されること' do
      visit new_admin_session_path
      expect(page).to have_content('メールアドレス')
      expect(page).to have_content('パスワード')
    end
  end

  context 'フォームの入力値が正常' do
    it 'ログインに成功' do
      visit new_admin_session_path
      fill_in 'admin_email', with: admin.email
      fill_in 'admin_password', with: admin.password
      click_button '管理者Login'
      expect(page).to have_content('ログインしました')
    end
    it "ログイン後注文一覧に遷移" do
      visit new_admin_session_path
      fill_in 'admin_email', with: admin.email
      fill_in 'admin_password', with: admin.password
      click_button '管理者Login'
      expect(current_path).to eq admin_orders_path
    end
  end

  describe 'ログイン後' do
    before do
      # customer = FactoryBot.create(:customer_test)
      @order = customer.orders.create(
        customer_id: 1,
        shipping_cost: 800,
        payment_method: 1,
        total_payment: 2000,
        status: 3,
        name: '田中',
        address: '東京都千代田区',
        postal_code: '1111111'
      )
      @genre = Genre.create(
        id: 1,
        name: "ケーキ"
      )
      @item = Item.create(
        id: 1,
        genre_id: 1,
        name: '絵のケーキ',
        introduction: 'ケーキ',
        price: 440,
        is_active: true,
        image_id: 1
      )
      @order_details = OrderDetail.create(
        id: 1,
        item_id: 1,
        order_id: 1,
        amount: 1,
        making_status: 0,
        price: 400,
      )
      visit new_admin_session_path
      fill_in 'admin_email', with: admin.email
      fill_in 'admin_password', with: admin.password
      click_button '管理者Login'
    end

    context '注文詳細画面のテスト' do
      it "注文詳細画面への遷移" do
        visit admin_orders_path
        find('.btn-link').click
        expect(page).to have_content("注文履歴詳細")
      end
      it "注文ステータスを入金確認にする" do
        visit admin_order_path(@order)
        find('.order_status').click
        select '入金確認', from: 'order[status]'
        find('#order-status').click
        expect(page).to have_content('注文ステータスを変更しました')
      end
      it "製作ステータスが製作中に更新される" do
        visit admin_order_path(@order)
        find('#order_detail_making_status').click
        select '製作中', from: 'order_detail[making_status]'
        find('#create-status').click
        expect(page).to have_content('製作中')
      end
      it "全て製作完了にすると注文ステータスが発送準備中になる" do
        visit admin_order_path(@order)
        find('#order_detail_making_status').click
        select '製作完了', from: 'order_detail[making_status]'
        find('#create-status').click
        expect(page).to have_content('発送準備中')
      end
      it "注文ステータスを発送済みに更新される" do
        visit admin_order_path(@order)
        find('.order_status').click
        select '発送済み', from: 'order[status]'
        find('#order-status').click
        expect(page).to have_content('発送済み')
      end
      it "管理者ログアウトを押すと管理者ログイン画面へ遷移する" do
        visit admin_order_path(@order)
        click_link('管理者ログアウト')
        expect(current_path).to eq new_admin_session_path
      end
    end

    context '会員マイページと注文履歴の確認' do
      before do
        visit new_customer_session_path
        fill_in 'customer_email', with: customer.email
        fill_in 'customer_password', with: customer.password
        click_button 'ログイン'
        visit customers_path
      end

      it 'トップ画面への遷移' do
        visit '/'
        expect(current_path).to eq '/'
      end
      it 'ログイン後のヘッダー表示が正しい' do
        expect(page).to have_content 'マイページ'
        expect(page).to have_content '商品一覧'
        expect(page).to have_content 'カート'
        expect(page).to have_content 'ログアウト'
      end
      it 'マイページへ遷移する' do
        visit customers_path
        click_link('マイページ')
        expect(current_path).to eq customers_path
      end
      it '注文一覧画面へ遷移する' do
        visit customers_path
        click_link('マイページ')
        find('#order-index').click
        expect(current_path).to eq orders_path
      end
      it '注文履歴詳細画面に遷移する' do
        visit customers_path
        click_link('マイページ')
        find('#order-index').click
        click_link('注文詳細')
        expect(current_path).to eq order_path(@order)
      end
      it '注文ステータスが発送済みになっている' do
        visit customers_path
        click_link('マイページ')
        find('#order-index').click
        click_link('注文詳細')
        expect(page).to have_content('発送準備中')
      end
    end
  end
end