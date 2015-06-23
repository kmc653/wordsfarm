require 'spec_helper'

describe "Create payment on successful charge" do
  let(:event_data) do
    {
      "id" => "evt_16GhfsE7JwniA027pkrEBaL2",
      "created" => 1435028532,
      "livemode" => false,
      "type" => "charge.succeeded",
      "data" => {
        "object" => {
          "id" => "ch_16GhfsE7JwniA0275TcjmIhk",
          "object" => "charge",
          "created" => 1435028532,
          "livemode" => false,
          "paid" => true,
          "status" => "succeeded",
          "amount" => 500,
          "currency" => "usd",
          "refunded" => false,
          "source" => {
            "id" => "card_16GhfqE7JwniA027tByk7SYK",
            "object" => "card",
            "last4" => "4242",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 6,
            "exp_year" => 2017,
            "fingerprint" => "VBjjFK12L1YtJfTB",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil,
            "dynamic_last4" => nil,
            "metadata" => {},
            "customer" => nil
          },
          "captured" => true,
          "balance_transaction" => "txn_16GhfsE7JwniA027VoLfKSdT",
          "failure_message" => nil,
          "failure_code" => nil,
          "amount_refunded" => 0,
          "customer" => nil,
          "invoice" => nil,
          "description" => "kevin@example.com",
          "dispute" => nil,
          "metadata" => {},
          "statement_descriptor" => nil,
          "fraud_details" => {},
          "receipt_email" => nil,
          "receipt_number" => nil,
          "shipping" => nil,
          "destination" => nil,
          "application_fee" => nil,
          "refunds" => {
            "object" => "list",
            "total_count" => 0,
            "has_more" => false,
            "url" => "/v1/charges/ch_16GhfsE7JwniA0275TcjmIhk/refunds",
            "data" => []
          }
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_6TezrPwtwVTyQ9",
      "api_version" => "2015-02-18"
    }
  end
  it "creates a payment with the webhook from stripe for charge succeeded", :vcr do
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with user", :vcr do
    kevin = Fabricate(:user, email: "kevin@example.com")
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(kevin)
  end

  it "creates the payment with the amount", :vcr do
    kevin = Fabricate(:user, email: "kevin@example.com")
    post "/stripe_events", event_data
    expect(Payment.first.amount).to eq(500)
  end

  it "creates the payment with reference_id", :vcr do
    kevin = Fabricate(:user, email: "kevin@example.com")
    post "/stripe_events", event_data
    expect(Payment.first.reference_id).to eq("ch_16GhfsE7JwniA0275TcjmIhk")
  end
end