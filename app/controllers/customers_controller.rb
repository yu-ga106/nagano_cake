class CustomersController < ApplicationController
  before_action :authenticate_customer!# , unless: :admin_signed_in?

  def show
    @customer = current_customer
  end

  def quit
    @customer = current_customer
  end

  def out
    @customer = current_customer
    @customer.update(is_deleted: true)
    reset_session
    redirect_to root_path, notice: "退会しました またのご利用お待ちしております"
  end
end