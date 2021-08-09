class Item < ApplicationRecord
  belongs_to :genre
  has_many :customers, through: :cart_items
  has_many :cart_items
  has_many :order_details
  has_many :orders, through: :order_details

  validates :genre_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :introduction, presence: true, length: { maximum: 300 }
  validates :price, presence: true

  attachment :image

  #------enumで数値指定-------
  # enum is_active: { 販売中: true, 販売停止中: false }
  #---------------------------

  def self.get_genre_list # カテゴリー一覧を所得するメソッド
    genre_str = Genre.all.pluck(:name)
    cate_hash = genre_str.zip(1..genre_str.size)
  end

  def self.admin?(customer) # とりあえず、アドミンかどうか確認出来るメソッドを仮設
    "Admin" == customer.class.name # <#%= Item.admin?(current_user) %>
  end
end