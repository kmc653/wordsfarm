require 'spec_helper'

feature "user login" do
  scenario "with valid email and password" do
    kevin = Fabricate(:user, email: 'kevin@example.com', password: 'kevin', full_name: "Kevin Chang")
    login(kevin)
    page.should have_content kevin.full_name
  end
end