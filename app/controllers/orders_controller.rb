class OrdersController < ApplicationController
  before_action :authenticate_customer!# , unless: :admin_signed_in?

  def index
    @orders = current_customer.orders
  end

  def current_index
    @orders = Order.where(customer_id: params[:id]).page(params[:page]).per(10)
    render :index
  end

  def today_order_index
    now = Time.current
    @orders = Order.where(created_at: now.all_day).page(params[:page]).per(10)
    render :index
  end

  def log
    @cart_items = current_customer.cart_items
    if session[:order] == {}
      redirect_to new_order_path
    else
      @order = Order.new(session[:order])
    end
  end

  def new
    @customer = current_customer
    @order = Order.new
    @addresses = Address.where(customer: current_customer)
  end

  def create

    # session[:order].clear if session[:order] == nil

    pay_amount = Order.total_amount_calculator(current_customer.cart_items)
    shipping_cost = 800

    @order = Order.new(order_params)

    @order.customer_id = current_customer.id
    @order.total_payment = pay_amount + shipping_cost
    @order.shipping_cost = shipping_cost

    if params[:order][:address_selection] == "my_home"
      @order.address = current_customer.address
      @order.name = current_customer.last_name
      @order.postal_code = current_customer.postal_code
    end

    if params[:order][:address_selection] == "addresses"
      address = Address.find(params[:order][:address_id])
      @order.address = address.address
      @order.name = address.name
      @order.postal_code = address.postal_code
    end

    if params[:order][:address_selection] == "new_address"
      if [] == Address.where(customer_id: current_customer.id, address: @order.address, name: @order.name, postal_code: @order.postal_code)
        Address.create(customer_id: current_customer.id, address: @order.address, name: @order.name, postal_code: @order.postal_code)
      end
    end

    if @order.valid?
      session[:order] = @order
      redirect_to log_orders_path
    else
      @customer = current_customer
      @addresses = Address.where(customer: current_customer)
      render :new
    end
  end

  def show
    @order = Order.find(params[:id])
    @order_details = @order.order_details
  end

  def completed
    order = Order.create(order_params)
    current_customer.items.each do |cart_item|
      OrderDetail.create(item_id: cart_item.id, order_id: order.id, amount: cart_item.cart_items[0].amount, making_status: 0, price: cart_item.price)
    end

    CartItem.where(customer_id: current_customer.id).destroy_all
    session[:order].clear
    redirect_to thanks_orders_path(message: "thank_you_for_purchasing_it")
  end

  def thanks
    unless params[:message] == "thank_you_for_purchasing_it"
      redirect_to customers_path
    end
  end

  private

  def order_params
    params.require(:order).permit(
      :customer_id,
      :address,
      :total_payment,
      :payment_method,
      :name,
      :postal_code,
      :shipping_cost,
      :status,
      :created_at,
      :updated_at
    )
  end
end