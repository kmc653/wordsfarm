class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user
    mail to: user.email, from: "info@wordsfarm.com", subject: "Welcome to WordsFarm!"
  end

  def send_forgot_password(user)
    @user = user
    mail to: user.email, from: "info@wordsfarm.com", subject: "Please reset your password"
  end

  def send_invitation_mail(invitation)
    @invitation = invitation
    mail to: invitation.recipient_email, from: "info@wordsfarm.com", subject: "Invitation to join WordsFarm"
  end
end