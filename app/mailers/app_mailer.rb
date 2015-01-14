class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user
    mail to: user.email, from: "info@wordsfarm.com", subject: "Welcome to WordsFarm!"
  end

  def send_forgot_password(user)
    @user = user
    mail to: user.email, from: "info@wordsfarm.com", subject: "Please reset your password"
  end
end