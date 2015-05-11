require 'spec_helper'

describe DonationsController do
  describe "POST create" do
    
    before do
      set_current_user
    end

    context "with a successful charge" do
      
      before do
        charge = double('charge')
        charge.stub(:successful?).and_return(true)
        StripeWrapper::Charge.stub(:create).and_return(charge)

        post :create, token: '123'
      end

      it "sets the flash success message" do
        flash[:success].should == 'Thank you for your generous support!'
      end
      it "redirects to the new dnation page" do
        response.should redirect_to donate_path
      end
    end

    context "with an failed charge" do
      
      before do
        charge = double('charge')
        charge.stub(:successful?).and_return(false)
        charge.stub(:error_message).and_return('Your card was declined')
        StripeWrapper::Charge.stub(:create).and_return(charge)
        post :create, token: '123'
      end

      it "sets the flash error message" do
        flash[:error].should == 'Your card was declined'
      end
      it "redirects to the new dnation page" do
        response.should redirect_to donate_path
      end
    end
  end
end