# This class contains the actions which send emails
# and text messages to users using ActionMailer
class UserMailer < ActionMailer::Base
  # Indicates the default email address that appears in the
  # from field of any emails or texts sent to users
  default :from => "admin@g8keep.com"
  
  # This function sends a welcome email to the user passed
  # as a parameter
  def welcome_email(user)
	@user = user
	@url = "http://g8keep.com/signin"
    mail(:to => user.personal_email,
         :subject => "Welcome to g8keep")
  end
  
  # This function sends an SMS message to a user passed as a paramater
  # of the contact information for the requested user passed as
  # another parameter
  def text_information(requested_user, user)
	@requested_user = requested_user
	if (user.service_provider == "Alltel")
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
