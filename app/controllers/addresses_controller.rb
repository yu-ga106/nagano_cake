class AddressesController < ApplicationController
  before_action :authenticate_customer!# , unless: :admin_signed_in?

  def index
    @customer = Customer.find(current_customer.id)
    @addresses = @customer.addresses
    @address = Address.new
  end

  def create
    @address = Address.new(address_params)
    @address.customer_id = current_customer.id
    if @address.save
      redirect_to addresses_path
    else
      render 'index'
    end
  end

  def edit
    @address = Address.find(params[:id])
  end

  def update
    @address = Address.find(params[:id])
    if @address.update(address_params)
      redirect_to addresses_path
    else
      render :edit
    end
  end

  def destroy
    @address = Address.find(params[:id])
    @address.destroy
    redirect_to addresses_path
  end

  private

  def address_params
    params.require(:address).permit(
      :name,
      :postal_code,
      :address
    )
  end
end