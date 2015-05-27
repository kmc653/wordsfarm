require "spec_helper"

feature 'User invites friend' do
  scenario 'User successfully invites friend and invitation is accepted' do
    allen = Fabricate(:user)
    login(allen)
    
    invite_a_friend
    friend_accepts_invitation
    
    friend_should_follow(allen)
    inviter_should_follow_friend(allen)

    clear_emails
  end

  def invite_a_friend
    visit new_invitation_path
    fill_in "Friend's Name", with: "Kevin Chang"
    fill_in "Friend's Email Address", with: "chang@example.com"
    fill_in "Message", with: "Hello please join this site."
    click_button "Send Invitation"
    logout
  end

  def friend_accepts_invitation
    open_email("chang@example.com")
    current_email.click_link "Accept this invitation"
    fill_in "Password", with: 'chang'
    fill_in "Full Name", with: 'Kevin Chang'
    click_button "Sign Up"
  end

  def friend_should_follow(user)
    click_link '朋友'
    page.should have_content user.full_name
  end

  def inviter_should_follow_friend(inviter)
    login(inviter)
    click_link '朋友'
    page.should have_content "Kevin Chang"
  end
end