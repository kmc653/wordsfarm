class PagesController < ApplicationController
  def welcome
    redirect_to sort_by_created_date_path(current_user) if current_user
  end
end