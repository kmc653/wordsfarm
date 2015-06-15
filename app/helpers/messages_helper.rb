module MessagesHelper
  def recipients_options
    s = ''
    User.all.each do |user|
      s << "<option value='#{user.id}'>#{user.full_name}</option>"
    end
    s.html_safe
  end
end