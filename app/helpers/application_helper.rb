module ApplicationHelper
  def current_cart
    @order = Order.find(params[:id])
    @order_details = @order.order_details
  end

  # 小数点切り捨てはfloor,３桁区切りはto_s(:delimited)
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
    total_payment(current_cart) + order.shipping_cost.to_i
  end
end