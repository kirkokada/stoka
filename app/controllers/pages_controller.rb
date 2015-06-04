class PagesController < ApplicationController
  def home
    return unless current_user && current_user.instagram_authenticated?
    @user_follows = current_user.instagram_follows
  end
end
