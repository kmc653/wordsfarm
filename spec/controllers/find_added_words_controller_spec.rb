require 'spec_helper'

describe FindAddedWordsController do
  
  describe "POST find_added_word" do

    before do
      kevin = Fabricate(:user)
      set_current_user(kevin)
      vocabulary = Vocabulary.new( word: 'zoo', part_of_speech: 'abc', example: 'abc', user_id: kevin.id)
      vocabulary.save
    end

    context "with existing word" do
      
      it "find the word" do
        post :find_added_word, word: 'zoo'
        expect(assigns(:word).word).to eq('zoo') 
      end
      
      it "show flash successful message" do
        post :find_added_word, word: 'zoo'
        expect(flash[:success]).to eq("Found Successfully!")
      end
    end

    context "with nonexisting word" do
      
      it "couldn't find the word" do
        post :find_added_word, word: 'abc'
        expect(Vocabulary.exists?(word: 'abc')).to be_falsey
      end
      it "show flash error message" do
        post :find_added_word, word: 'abc'
        expect(flash[:error]).to be_present
      end
    end
  end
end