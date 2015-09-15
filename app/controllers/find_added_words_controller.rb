class FindAddedWordsController < ApplicationController
  def find_added_word
    if params[:word]
      if Vocabulary.exists?(word: params[:word])
        @word = Vocabulary.find_by word: params[:word]
        flash[:success] = "Found Successfully!"
      else
        flash[:error] = "Couldn't find '#{params[:word]}'. Please try another one."
      end
    end
  end
end