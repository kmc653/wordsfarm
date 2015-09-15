class AddSearchedWordsController < ApplicationController
  def search
    if params[:word]
      @word = params[:word]
      respond = DictionaryWrapper::Search.create(@word)
      
      if respond.entry == nil
        flash[:error] = "Couldn't find '#{@word}'. Please try another one."
        redirect_to search_path
      else
        @entry_def = respond.entry_def # get the definition of the word
        @pos = respond.part_of_speech      # get the part of speech
        @degree = respond.degree_of_word   # get the degree of word
        @vi = respond.examples             # get the examples
        
        #respond.move_examples_away_from_def
        if @entry_def.css("vi")         # modify the the parent of vi tag from dt to def 
          vi = @entry_def.css("vi")
          vi.each do |ex|
            ex.parent = @entry_def
          end
        end
      end
    end
  end

  def create   
  end

  def show
  end
end