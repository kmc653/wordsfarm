require 'spec_helper'

feature 'User resets password' do
  scenario 'user successfully resets the password' do
    kevin = Fabricate(:user, password: 'old_password')
    visit login_path
    click_link "Forgot Password?"
    fill_in "Email Address", with: kevin.email
    click_button "Send Email"

    open_email(kevin.email)
    current_email.click_link("Reset My Password")

    fill_in "New Password", with: "new_password"
    click_button "Reset Password"

    fill_in "Email Address", with: kevin.email
    fill_in "Password", with: "new_password"
    click_button "Login"
    expect(page).to have_content("#{kevin.full_name}'s 單字集")

    clear_email
  end
end