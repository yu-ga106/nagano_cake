class OrderDetail < ApplicationRecord
  belongs_to :item
  belongs_to :order

  validates :making_status, presence: true
  validates :amount, presence: true
  validates :price, presence: true

  enum making_status: { "着手不可": 0, "製作待ち": 1, "製作中": 2, "製作完了": 3 }
end