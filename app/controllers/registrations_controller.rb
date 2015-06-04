class RegistrationsController < Devise::RegistrationsController
  def create
    super
    session[:omniauth] = nil unless @user.new_record?
  end

  private

  def build_resource(*args)
    super
    return unless session[:omniauth]
    @user.apply_omniauth(session[:omniauth])
    @user.valid?
  end

  def update_resource(resource, params)
    if current_user.authentications.any? &&
       current_user.encrypted_password.blank?
      set_password(resource, params)
    end
    super
  end

  def set_password(resource, params)
    return unless params[:password] == params[:password_confirmation]
    resource.password = params[:password]
    resource.update_attribute(
      :encrypted_password, resource.encrypted_password)
    params[:current_password] = params[:password]
  end
end
