require 'spec_helper'

describe StripeWrapper::Charge do
  
  before do
    StripeWrapper.set_api_key
  end

  let(:token) do 
    Stripe::Token.create(
      :card => {
        :number => card_number,
        :exp_month => 3,
        :exp_year => 2017,
        :cvc => 314
      }
    ).id
  end

  context "with valid card", :vcr do
    let(:card_number) { '4242424242424242' }

    it "charges the card successfully" do
      response = StripeWrapper::Charge.create(source: token)
      response.should be_successful
    end
  end
  context "with invalid card", :vcr do
    let(:card_number) { '4000000000000002' }
    let(:response) { StripeWrapper::Charge.create(source: token) }

    it "does not charge the card successfully" do
      response.should_not be_successful
    end

    it "contains an error message" do
      response.error_message.should == 'Your card was declined.'
    end
  end
end