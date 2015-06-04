class AuthenticationsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    auth = Authentication.find(params[:id])
    flash[:notice] = "#{auth.provider.titleize} account unlinked"
    auth.destroy
    redirect_to root_url
  end
end
