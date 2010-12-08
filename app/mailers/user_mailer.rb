class UserMailer < ActionMailer::Base
  default :from => "admin@g8keep.com"
  
  def welcome_email(user)
	@user = user
	@url = "http://g8keep.com/signin"
    mail(:to => user.personal_email,
         :subject => "Welcome to g8keep")
  end
end
