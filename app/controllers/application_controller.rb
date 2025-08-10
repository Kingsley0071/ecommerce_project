class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Devise parameter sanitization
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :current_cart

  def current_cart
    session[:cart] ||= {}
    session[:cart]
  end

  private

  def configure_permitted_parameters
    # Permit username for sign up and account update
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :username, :address, :city, :postal_code, :province ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :username, :address, :city, :postal_code, :province ])
  end
end
