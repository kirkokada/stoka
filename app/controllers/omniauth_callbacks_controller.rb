class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    if auth
      sign_in_and_redirect auth.user
    elsif current_user
      authenticate_user
    else
      create_user_from_authentication
    end
  end

  alias_method :instagram, :all

  private

  def omniauth
    @omniauth ||= request.env['omniauth.auth']
  end

  def auth
    @auth ||= Authentication.find_by_provider_and_uid(omniauth['provider'],
                                                      omniauth['uid'])
  end

  def sign_in_and_redirect(user)
    flash[:notice] = 'Signed in'
    sign_in user
    redirect_to root_url
  end

  def authenticate_user
    current_user.authentications.create(
      provider: omniauth['provider'],
      uid:      omniauth['uid'],
      token:    omniauth['credentials']['token'])
    flash[:notice] = 'Authentication successful!'
    redirect_to root_url
  end

  def create_user_from_authentication
    user = initialize_user_from_authentication
    if user.save
      sign_in_and_redirect user
    else
      session['omniauth'] = omniauth.except('extra')
      redirect_to new_user_registration_url
    end
  end

  def initialize_user_from_authentication
    user = User.new(username: omniauth['info']['nickname'])
    user.authentications.build(provider: omniauth['provider'],
                               uid:      omniauth['uid'],
                               token:    omniauth['credentials']['token'])
    user
  end
end
