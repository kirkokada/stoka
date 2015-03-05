class RegistrationsController < Devise::RegistrationsController
  def create
    super
    session[:omniauth] = nil unless @user.new_record?
  end
  private
    def build_resource(*args)
      super
      if session[:omniauth]
        @user.apply_omniauth(session[:omniauth])
        @user.valid?
      end
    end

    def update_resource(resource, params)
      if current_user.authentications.any? && current_user.encrypted_password.blank?
        if params[:password] == params[:password_confirmation]
          resource.password = params[:password]
          resource.update_attribute(:encrypted_password, resource.encrypted_password)
          params[:current_password] = params[:password]
          super
        else
          super
        end
      else
        super
      end
    end
end
