class RelationshipsController < ApplicationController
  before_action :require_user

  def index
    @relationships = current_user.following_relationships
  end

  def create
    leader = User.find(params[:leader_id])
    relationship = Relationship.create(follower: current_user, leader: leader) if current_user.can_follow?(leader)
    redirect_to people_path
  end

  def destroy
    relationship = Relationship.where(id: params[:id]).first
    relationship.destroy if relationship.follower == current_user
    redirect_to people_path
  end
end