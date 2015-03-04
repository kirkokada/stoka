class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    omniauth = request.env['omniauth.auth']
    auth = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])

    # Authentication exists
    if auth
      flash[:notice] = "Signed in"
      sign_in auth.user
      redirect_to root_url

    # User is logged in, but authentication doesn't exist
    elsif current_user
      current_user.authentications.create(provider: omniauth['provider'], 
                                          uid:      omniauth['uid'], 
                                          token:    omniauth['credentials']['token'])
      flash[:notice] = "Authentication successful!"
      sign_in auth.user
      redirect_to root_url

    # New user
    else
      user = User.new { |user| user.username = omniauth['info']['nickname'] }
      user.authentications.build(provider: omniauth['provider'], 
                                 uid:      omniauth['uid'],
                                 token:    omniauth['credentials']['token'])
      if user.save
        flash[:notice] = "Signed in"
        sign_in user
        redirect_to root_url
      else
        session['omniauth'] = omniauth.except('extra')
        redirect_to new_user_registration_url
      end
    end
  end

  alias_method :instagram, :all
end
