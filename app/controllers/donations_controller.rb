class DonationsController < ApplicationController
  def create
    @user = current_user
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    token = params[:stripeToken]
    begin
      Stripe::Charge.create(
        :amount => 500,
        :currency => "usd",
        :source => token,
        :description => "Donation from #{@user.email}."
      )
      flash[:success] = "Thank you for your generous support!"
      redirect_to new_donation_path
    rescue Stripe::CardError => e
      flash[:errors] = e.message
      redirect_to new_donation_path
    end
  end
end