class MarkersController < ApplicationController
  def create
    @username = params[:ig_username]
    ig_access_token = current_user && auth ? auth.token : ' '
    @mf = MediaFetcher.new(ig_username: @username,
                           ig_access_token: ig_access_token)
    if @mf.valid?
      @media = @mf.ig_recent_media
      respond_to { |format| format.js }
    else
      respond_to { |format| format.js { render 'display_errors' } }
    end
  end

  private

  def auth
    @auth ||= current_user.authentications.find_by_provider('instagram')
  end
end
