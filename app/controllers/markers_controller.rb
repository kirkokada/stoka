class MarkersController < ApplicationController

	def create
		@username = params[:ig_username]
		if current_user && auth = current_user.authentications.find_by_provider('instagram')
			ig_access_token = auth.token
		else
			ig_access_token = ""
		end
		@mf = MediaFetcher.new(ig_username: @username, ig_access_token: ig_access_token)
		if @mf.valid?
			@media = @mf.ig_recent_media
			respond_to do |format|
				format.js 
			end
		else
			respond_to do |format|
				format.js { render 'display_errors' }
			end
		end
	end
end
