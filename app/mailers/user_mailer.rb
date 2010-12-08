class UserMailer < ActionMailer::Base
  default :from => "admin@g8keep.com"
  
  def welcome_email(user)
	@user = user
	@url = "http://g8keep.com/signin"
    mail(:to => user.personal_email,
         :subject => "Welcome to g8keep")
  end
  
  def text_information(requested_user, user)
	@requested_user = requested_user
	if (user.service_provider == "Alltell")
		address = user.cell_phone + "@message.alltel.com"
	elsif (user.service_provider == "AT&T")
		address = user.cell_phone + "@txt.att.net"
	elsif (user.service_provider == "MetroPCS")
		address = user.cell_phone + "@mymetropcs.com"
	elsif (user.service_provider == "Nextel")
		address = user.cell_phone + "@messaging.nextel.com"
	elsif (user.service_provider == "Powertel")
		address = user.cell_phone + "@ptel.net"
	elsif (user.service_provider == "Sprint")
		address = user.cell_phone + "@messaging.sprintpcs.com"
	elsif (user.service_provider == "SunCom")
		address = user.cell_phone + "@tms.suncom.com"
	elsif (user.service_provider == "T-Mobile")
		address = user.cell_phone + "@tmomail.net"
	elsif (user.service_provider == "US Cellular")
		address = user.cell_phone + "@email.uscc.net"
	elsif (user.service_provider == "Verizon")
		address = user.cell_phone + "@vtext.com"
	elsif (user.service_provider == "Virgin Mobile")
		address = user.cell_phone + "@vmobl.com"
	end
	mail(:to => address,
		 :subject => "Contact Information")
	end
end
