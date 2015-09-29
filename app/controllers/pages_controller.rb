class PagesController < ApplicationController
  def welcome
    redirect_to all_users_path if current_user
  end
end