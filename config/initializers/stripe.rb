Stripe.api_key = ENV['STRIPE_SECRET_KEY']

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    user = User.where(email: event.data.object.description).first
    Payment.create(user: user, amount: event.data.object.amount, reference_id: event.data.object.id)
  end
end