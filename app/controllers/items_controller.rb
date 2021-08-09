class ItemsController < ApplicationController
  before_action :authenticate_customer!, except: [:show, :index, :top, :about]# , unless: :admin_signed_in?

  def top
    @items = Item.where(is_active: true).page(params[:page]).per(4)
  end

  def index
    @items = Item.where(is_active: true).page(params[:page]).per(8)
  end

  def search
    @items = Item.where(genre_id: params[:genre_id]).page(params[:page]).per(8)
    render "index"
  end

  def show
    @item = Item.find(params[:id])
    @cart_item = CartItem.new
  end

  def log
  end

  def thanks
  end

  private

  def item_params
    params.require(:item).permit(:name, :introduction, :price, :image, :is_active, :genre_id)
  end
end