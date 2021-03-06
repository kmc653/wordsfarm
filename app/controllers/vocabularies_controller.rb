class VocabulariesController < ApplicationController
  before_action :require_user
  
  def new
    @vocabulary = Vocabulary.new
  end

  def create
    @vocabulary = Vocabulary.new(voca_params)
    @vocabulary.creator = current_user
    if @vocabulary.save
      flash[:success] = "You've added a new word."
      redirect_to sort_by_created_date_path(current_user)
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
    redirect_to sort_by_created_date_path(current_user)
  end

  def edit
    @vocabulary = Vocabulary.find(params[:id])
  end

  def update
    @vocabulary = Vocabulary.find(params[:id])
    if @vocabulary.update(voca_params)
      flash[:success] = "edit successfully!"
      redirect_to sort_by_created_date_path(current_user)
    else
      flash[:error] = "There are something wrong with your update."
      render :edit
    end
  end

  def search_added_word
    if params[:word].present?
      @results = Vocabulary.search(params[:word]).records.to_a
    else
      flash[:error] = "Couldn't find '#{params[:word]}'. Please try another one."
    end
  end

  private

  def voca_params
    params.require(:vocabulary).permit(:word, :part_of_speech, :example, :category_id)
  end
end