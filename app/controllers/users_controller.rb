class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      handle_invitation
      AppMailer.send_welcome_email(@user).deliver
      session[:user_id] = @user.id
      flash[:success] = "You are registered."
      redirect_to sort_by_created_date_path(@user)
    else
      render :new
    end
  end

  def sort_by_created_date
    @user = User.find(params[:id])
  end

  def sort_by_category
    @category_id = params[:user][:categories].to_i if params[:user]
    @user = User.find(params[:id])
  end

  def new_with_invitation_token
    invitation = Invitation.where(token: params[:token]).first
    if invitation
      @user = User.new(email: invitation.recipient_email)
      @invitation_token = invitation.token
      render :new
    else
      redirect_to expired_token_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end

  def handle_invitation
    if params[:invitation_token].present?
      invitation = Invitation.where(token: params[:invitation_token]).first
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_column(:token, nil)
    end
  end
end