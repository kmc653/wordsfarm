require 'spec_helper'

describe VocabulariesController do
  describe "GET new" do
    
    context "with authenticated users" do
      it "set @vocabulary" do
        kevin = Fabricate(:user)
        session[:user_id] = kevin.id
        get :new
        expect(assigns(:vocabulary)).to be_instance_of(Vocabulary) 
      end
    end

    context "with unauthenticated users" do
      it "redirects to sign in path" do
        get :new
        expect(response).to redirect_to login_path
      end
    end

  end

  describe "POST create" do
    context "with authenticated users" do
      context "with valid input" do
        it "creates the word" do
          kevin = Fabricate(:user)
          session[:user_id] = kevin.id
          post :create, vocabulary: Fabricate.attributes_for(:vocabulary), user_id: kevin.id
          expect(Vocabulary.count).to eq(1)
        end

        it "redirects to the user show page" do
          kevin = Fabricate(:user)
          session[:user_id] = kevin.id
          post :create, vocabulary: Fabricate.attributes_for(:vocabulary), user_id: kevin.id
          expect(response).to redirect_to kevin
        end

        it "create a word associated with the login user" do
          kevin = Fabricate(:user)
          session[:user_id] = kevin.id
          post :create, vocabulary: Fabricate.attributes_for(:vocabulary), user_id: kevin.id
          expect(Vocabulary.first.user_id).to eq(kevin.id)
        end
      end
    end

    context "with unauthenticated users" do
      it_behaves_like "require login" do
        let(:action) { post :create, vocabulary: Fabricate.attributes_for(:vocabulary) }
      end
    end  
  end

  describe "DELETE destroy" do

    it_behaves_like "require login" do
      let(:action) { delete :destroy, id: 3 }
    end

    it "redirects to the user's page" do
      kevin = Fabricate(:user)
      set_current_user(kevin)
      word = Fabricate(:vocabulary, creator: kevin)
      delete :destroy, id: word.id
      expect(response).to redirect_to user_path(kevin)
    end

    it "delete the word" do
      kevin = Fabricate(:user)
      set_current_user(kevin)
      word = Fabricate(:vocabulary, creator: kevin)
      delete :destroy, id: word.id
      expect(Vocabulary.count).to eq(0)
    end

    it "does not delete the word if the word does not belong to the current user" do
      kevin = Fabricate(:user)
      bob = Fabricate(:user)
      set_current_user(kevin)
      word = Fabricate(:vocabulary, creator: bob)
      delete :destroy, id: word.id
      expect(Vocabulary.count).to eq(1)
    end
  end

  describe "GET edit" do
    it_behaves_like "require login" do
      let(:action) { get :edit, id: 3 }
    end

    it "set @vocabulary" do
      kevin = Fabricate(:user)
      set_current_user(kevin)
      word = Fabricate(:vocabulary, creator: kevin)
      get :edit, id: word.id
      expect(assigns(:vocabulary)).to be_instance_of(Vocabulary)
    end
  end

  describe "PATCH update" do
    it "edit the word" do
      kevin = Fabricate(:user)
      set_current_user(kevin)
      word = Fabricate(:vocabulary, creator: kevin)
      patch :update, id: word.id, vocabulary: { word: 'word', part_of_speech: 'verb', example: '12345' }
      expect(Vocabulary.first.example).to eq('12345')
    end

    it "redirects to the user's page" do
      kevin = Fabricate(:user)
      set_current_user(kevin)
      word = Fabricate(:vocabulary, creator: kevin)
      patch :update, id: word.id, vocabulary: { word: 'word', part_of_speech: 'verb', example: '12345' }
      expect(response).to redirect_to user_path(kevin)
    end

    it "flash error if edit does not finish" do
      kevin = Fabricate(:user)
      set_current_user(kevin)
      word = Fabricate(:vocabulary, creator: kevin)
      patch :update, id: word.id, vocabulary: { word: 'word', part_of_speech: 'verb', example: '' }
      expect(flash[:error]).to eq("There are something wrong with your update.")
    end
  end
end