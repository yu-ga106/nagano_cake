class CartItemsController < ApplicationController
  before_action :authenticate_customer!# , unless: :admin_signed_in?

  def index
    @cart_items = CartItem.where(customer_id: current_customer.id)
  end

  def create
    if @already_cart_item = CartItem.find_by(customer_id: current_customer.id, item_id: params[:item_id]) # 既にカードに追加済みの商品には更新処理
      @already_cart_item.update(amount: params[:amount])
      redirect_to cart_items_path
    else
      @new_art_item = CartItem.create(customer_id: current_customer.id, item_id: params[:item_id], amount: params[:amount]) # 新規カート追加の商品は新規追加処理
      redirect_to cart_items_path
    end
  end

  def update
    @cart_item = CartItem.find(params[:id])
    @cart_item.update(amount: params[:cart_item][:amount])
    @cart_item.save
    redirect_to cart_items_path

  end

  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    redirect_back(fallback_location: root_path)
  end

  def all_destroy
    @cart_items = CartItem.where(customer_id: current_customer.id)
    @cart_items.destroy_all
    redirect_back(fallback_location: root_path)
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:amount)
  end
end