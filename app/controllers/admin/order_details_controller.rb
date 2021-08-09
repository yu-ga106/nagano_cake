class Admin::OrderDetailsController < ApplicationController
  before_action :authenticate_admin!

  def update

    @order_detail = OrderDetail.find(params[:id])
    @order_details = @order_detail.order.order_details
    making_status = OrderDetail.making_statuses[order_detail_params[:making_status]]

    if @order_detail.update(order_detail_params)

      if making_status >=  OrderDetail.making_statuses["製作中"]
        @order_detail.order.update(status: 2)
      else
        @order_detail.order.update(status: 1)
      end

      if @order_details.pluck(:making_status).reject { |n| n == OrderDetail.making_statuses.keys[-1] }.blank?
        @order_detail.order.update(status: 3)
      end

      flash[:notice] = "製作ステータスを変更しました"
      redirect_to admin_order_path(@order_detail.order)
    else
      render "show"
    end
  end

  private

  def order_detail_params
    params.require(:order_detail).permit(:making_status)
  end
end