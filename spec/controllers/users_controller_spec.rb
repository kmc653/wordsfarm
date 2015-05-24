require 'spec_helper'

describe UsersController do
  describe "GET index" do
    it "show all users" do
      get :index
      expect(assigns(:users)).to eq(User.all)
    end
  end

  describe "GET new" do
    it "set @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "with valid input" do
      
      before do
        post :create, user: Fabricate.attributes_for(:user)
      end

      it "creates the user" do
        expect(User.count).to eq(1)
      end
      
      it "redirect to the user page" do
        expect(response).to redirect_to sort_by_created_date_path(User.first)
      end

      it "make the user follow the inviter" do
        kevin = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: kevin, recipient_email: 'ellie@example.com', recipient_name: 'Ellie Lai')
        post :create, user: { email: 'ellie@example.com', password: 'password', full_name: 'Ellie Lai' }, invitation_token: invitation.token
        ellie = User.where(email: 'ellie@example.com').first
        expect(ellie.follow?(kevin)).to be_truthy
      end

      it "make inviter follow the user" do
        kevin = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: kevin, recipient_email: 'ellie@example.com', recipient_name: 'Ellie Lai')
        post :create, user: { email: 'ellie@example.com', password: 'password', full_name: 'Ellie Lai' }, invitation_token: invitation.token
        ellie = User.where(email: 'ellie@example.com').first
        expect(kevin.follow?(ellie)).to be_truthy
      end

      it "expired the invitation upon acceptance" do
        kevin = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: kevin, recipient_email: 'ellie@example.com', recipient_name: 'Ellie Lai')
        post :create, user: { email: 'ellie@example.com', password: 'password', full_name: 'Ellie Lai' }, invitation_token: invitation.token
        ellie = User.where(email: 'ellie@example.com').first
        expect(Invitation.first.token).to be_nil
      end
    end

    context "with invalid input" do
      
      before do
        post :create, user: { password: 'password', full_name: 'Kevin Chang' }
      end

      it "does not create the user" do
        expect(User.count).to eq(0)
      end
      
      it "render the new template" do
        expect(response).to render_template :new
      end
      
      it "set @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end 

    context "sending emails" do

      after { ActionMailer::Base.deliveries.clear }

      it "sends out emails to the user with valid inputs" do
        post :create, user: { email: 'kevin@example.com', password: 'kevin', full_name: 'Kevin Chang' }
        expect(ActionMailer::Base.deliveries.last.to).to eq(['kevin@example.com'])
      end

      it "sends out emails containing the user's name with valid inputs" do
        post :create, user: { email: 'kevin@example.com', password: 'kevin', full_name: 'Kevin Chang' }
        expect(ActionMailer::Base.deliveries.last.body).to include('Kevin Chang')
      end

      it "does not send out email with invalid inputs" do
        post :create, user: { email: 'kevin@example.com' }
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

end