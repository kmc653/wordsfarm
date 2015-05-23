class CategoriesController < ApplicationController
  before_action :require_user

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(cate_params)
    @category.creator = current_user
    if @category.save
      flash[:success] = "You've created a new category."
      redirect_to category_path(current_user.id)
    else
      render :new
    end
  end

  def show
    @categories = Category.where(user_id: params[:id])
  end

private

def cate_params
  params.require(:category).permit(:name)
end

end