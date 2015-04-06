class VocabulariesController < ApplicationController
  before_action :require_user
  
  def new
    @vocabulary = Vocabulary.new
  end

  def create
    @vocabulary = Vocabulary.new(voca_params)
    @vocabulary.creator = current_user
    if @vocabulary.save
      flash[:notice] = "You've added a new word."
      redirect_to user_path(current_user)
    else
      render :new
    end
  end

  def destroy
    word = Vocabulary.find(params[:id])
    if current_user.vocabularies.include?(word)
      word.destroy 
      QueueItem.destroy_all(vocabulary_id: params[:id])
    end
    redirect_to user_path(current_user)
  end

  def edit
    @vocabulary = Vocabulary.find(params[:id])
  end

  def update
    @vocabulary = Vocabulary.find(params[:id])
    if @vocabulary.update(voca_params)
      flash[:notice] = "edit successfully!"
      redirect_to user_path(current_user)
    else
      flash[:error] = "There are something wrong with your update."
      render :edit
    end
  end

  private

  def voca_params
    params.require(:vocabulary).permit(:word, :part_of_speech, :example, :category_id)
  end
end