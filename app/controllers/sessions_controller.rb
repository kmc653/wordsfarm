class SessionsController < ApplicationController
  def new
    redirect_to sort_by_created_date_path(current_user) if current_user
  end

  def create
    user = User.where(email: params[:email]).first
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, you're logged in!"
      redirect_to current_user.admin? ? admin_users_path : sort_by_created_date_path(user)
    else
      flash[:error] = "Invalid email or password."
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You're logged out."
    redirect_to login_path
  end
end