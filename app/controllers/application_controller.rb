class ApplicationController < ActionController::Base

  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :email,
      :last_name_kana,
      :last_name,
      :first_name_kana,
      :first_name,
      :telephone_number,
      :postal_code,
      :address,
    ])
    devise_parameter_sanitizer.permit(:account_update, keys: [
      :email,
      :last_name_kana,
      :last_name,
      :first_name_kana,
      :first_name,
      :telephone_number,
      :postal_code,
      :address,
    ])
  end

  def after_sign_in_path_for(recource)
    if current_admin
      admin_orders_path
    else
      customers_path
    end
  end
end