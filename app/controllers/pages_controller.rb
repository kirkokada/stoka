class PagesController < ApplicationController
  def home
    if current_user && current_user.instagram_authenticated?
      @user_follows = current_user.instagram_follows
    end
  end
end
