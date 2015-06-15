class Admin::UsersController < ApplicationController
  def index
    @users = User.all.order('created_at DESC')
  end

  def destroy
    user = User.find(params[:id])
    if user.id == current_user.id
      flash[:error] = "You cannot delete yourself."
    else
      Relationship.destroy_all(leader_id: params[:id])
      QueueItem.destroy_all(creator_id: params[:id])
      Vocabulary.destroy_all(user_id: params[:id])
      user.destroy
      flash[:success] = "'#{user.full_name}' are deleted."
    end
    redirect_to admin_users_path
  end
end