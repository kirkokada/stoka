class MarkersController < ApplicationController

	def create
		@mf = MediaFetcher.new(ig_username: params[:ig_username])
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
