require 'spec_helper'

feature "Admin sees patronages" do
  background do
    kevin = Fabricate(:user, full_name: "Kevin Chang", email: "kevin@example.com")
    Fabricate(:payment, amount: 500, user: kevin)
  end

  scenario "admin can see patronages" do
    login(Fabricate(:admin))
    visit admin_payments_path
    expect(page).to have_content("$5.00")
    expect(page).to have_content("Kevin Chang")
    expect(page).to have_content("kevin@example.com")
  end
  scenario "user cannot see patronages" do
    login(Fabricate(:user))
    visit admin_payments_path
    expect(page).not_to have_content("$5.00")
    expect(page).to have_content("You do not have access to that area.")
  end
end