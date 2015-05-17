class DonationsController < ApplicationController
  before_action :require_user
  
  def create
    @user = current_user
    token = params[:stripeToken]

    charge = StripeWrapper::Charge.create( 
      :source => token, 
      :description => "Donation from #{@user.email}."
    )
    if charge.successful?
      flash[:success] = "Thank you for your generous support!"
      redirect_to donate_path
    else
      flash[:error] = charge.error_message
      redirect_to donate_path
    end
  end
end