require 'spec_helper'

feature 'User makes donation', js: true do
  
  before do
    kevin = Fabricate(:user)
    register(kevin)
    click_button 'Donate'
  end

  scenario "valid card number" do
    pay_with_credit_card('4242424242424242')

    page.should have_content("Thank you for your generous support!")
  end
  
  scenario "invalid card number" do
    pay_with_credit_card('4000000000000069')

    expect(page).to have_content("Your card has expired.")
  end
  
  scenario "declined card" do
    pay_with_credit_card('4000000000000002')

    expect(page).to have_content("Your card was declined.")
  end

  def pay_with_credit_card(card_number)
    fill_in 'card-number', with: card_number
    fill_in 'security-code', with: "235"
    select "7 - July", from: "date_month"
    select "2018", from: "date_year"
    click_button 'Submit Payment'
  end
end
