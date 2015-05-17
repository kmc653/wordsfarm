def set_current_user(user=nil)
  session[:user_id] = (user || Fabricate(:user)).id
end

def register(user)
  visit register_path
  fill_in "Email Address", with: user.email
  fill_in "Password", with: user.password
  fill_in "Full Name", with: user.full_name
  click_button "Sign Up"
end

def login(a_user=nil)
  user = a_user || Fabricate(:user)
  visit login_path
  fill_in "Email Address", with: user.email
  fill_in "Password", with: user.password
  click_button "Login"
end

def logout
  visit logout_path
end