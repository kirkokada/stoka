class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Override Devise default permitted parameters to allow login
  # with email or username

  def configure_permitted_parameters
    sign_up_param_sanitizer
    sign_in_param_sanitizer
    account_update_param_sanitizer
  end

  private

  def sign_up_param_sanitizer
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(
        :username,
        :email,
        :password,
        :password_confirmation,
        :remember_me)
    end
  end

  def sign_in_param_sanitizer
    devise_parameter_sanitizer.for(:sign_in) do |u|
      u.permit(
        :login,
        :username,
        :email,
        :password,
        :password_confirmation,
        :remember_me)
    end
  end

  def account_update_param_sanitizer
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(
        :email,
        :password,
        :password_confirmation,
        :current_password)
    end
  end
end
