require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "render new template for unauthenticated user" do
      get :new
      expect(response).to render_template(:new)
    end
    
    it "redirect to root page for authenticated user" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to root_path
    end
  end

  describe "POST create" do
    context "with valid credentials" do
      it "puts signed in user in the session" do
        kevin = Fabricate(:user)
        post :create, email: kevin.email, password: kevin.password
        expect(session[:user_id]).to eq(kevin.id)
      end
      
      it "redirect to root page" do
        kevin = Fabricate(:user)
        post :create, email: kevin.email, password: kevin.password
        expect(response).to redirect_to(root_path)
      end
      
      it "sets the notice" do
        kevin = Fabricate(:user)
        post :create, email: kevin.email, password: kevin.password
        expect(flash[:notice]).not_to be_blank
      end
    end

    context "with invalid credentials" do
      
      before do
        kevin = Fabricate(:user)
        post :create, email: kevin.email, password: kevin.password + 'aaaaa'
      end

      it "does not put the logged in user in the session" do
        expect(session[:user_id]).to be_nil
      end
      
      it "sets the errors" do
        expect(flash[:error]).not_to be_blank
      end
      
      it "redirect to the login in page" do
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "GET destroy" do
    
    before do
      session[:user_id] = Fabricate(:user).id
      get :destroy
    end

    it "clear the session for the user" do
      expect(session[:user_id]).to be_nil
    end
    
    it "redirect to the login page" do
      expect(response).to redirect_to login_path
    end
    
    it "set the notice" do
      expect(flash[:notice]).not_to be_blank
    end
  end
end