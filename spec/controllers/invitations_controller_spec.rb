require "spec_helper"

describe InvitationsController do
  describe "GET new" do
    it_behaves_like "require login" do
      let(:action) { get :new}
    end

    it "sets @invitation to a new invitation" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_new_record
      expect(assigns(:invitation)).to be_instance_of Invitation
    end
  end

  describe "POST create" do
    it_behaves_like "require login" do
      let(:action) { post :create}
    end

    after { ActionMailer::Base.deliveries.clear }

    context "with valid input" do
      it "redirects to the invitation page" do 
        set_current_user
        post :create, invitation: { recipient_name: "Mr. Anderson", recipient_email: "anderson@example.com", message: "Hey join WordsFarm!" }
        expect(response).to redirect_to new_invitation_path
      end
      it "create a invitation" do
        set_current_user
        post :create, invitation: { recipient_name: "Mr. Anderson", recipient_email: "anderson@example.com", message: "Hey join WordsFarm!" }
        expect(Invitation.count).to eq(1)
      end
      it "send email to the recipient" do
        set_current_user
        post :create, invitation: { recipient_name: "Mr. Anderson", recipient_email: "anderson@example.com", message: "Hey join WordsFarm!" }
        expect(ActionMailer::Base.deliveries.last.to).to eq(["anderson@example.com"])
      end
      it "sets the flash success message" do
        set_current_user
        post :create, invitation: { recipient_name: "Mr. Anderson", recipient_email: "anderson@example.com", message: "Hey join WordsFarm!" }
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid input" do
      it "renders new :new template" do
        set_current_user
        post :create, invitation: { recipient_email: "kevin@example.com", message: "Hey join WordsFarm!" }
        expect(response).to render_template :new
      end

      it "does not create an invitation" do
        set_current_user
        post :create, invitation: { recipient_email: "kevin@example.com", message: "Hey join WordsFarm!" }
        expect(Invitation.count).to eq(0)
      end

      it "does not send out an email" do
        set_current_user
        post :create, invitation: { recipient_email: "kevin@example.com", message: "Hey join WordsFarm!" }
        expect(ActionMailer::Base.deliveries).to be_empty
      end
      
      it "set @invitation" do
        set_current_user
        post :create, invitation: { recipient_email: "kevin@example.com", message: "Hey join WordsFarm!" }
        expect(assigns(:invitation)).to be_present
      end
    end
    
  end
end