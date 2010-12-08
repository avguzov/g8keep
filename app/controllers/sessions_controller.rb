# This controller stores all of the actions for views
# which are part of user sessions

class SessionsController < ApplicationController
  
  # This action defines the view for the sign-in page
  # of the website and specifies its title
  def new
	@title = "Sign in"
  end
  
  # This action signs a user in, authenticating the 
  # submitted username and password, signing the visitor
  # in and redirecting the visitor to the visitor's 
  # profile page, or flashing an invalid message and 
  # rendering the sign-in page again.
  def create
	user = User.authenticate(params[:session][:username],
							 params[:session][:password])
	
	if user.nil?
		flash.now[:error] = "Invalid username/password combination."
		@title = "Sign in"
		render 'new'
	else
		sign_in user
		redirect_back_or user
	end
  end
  
  # This method destroys the session, signing a user out and
  # redirecting the visitor back to the homepage
  def destroy
	sign_out
	redirect_to root_path
  end

end
