class AdminsController < ApplicationController
  before_action :ensure_admin

  def ensure_admin
    if !current_user.admin?
      flash[:error] = "You do not have access to that area."
      redirect_to root_path
    end
  end
end