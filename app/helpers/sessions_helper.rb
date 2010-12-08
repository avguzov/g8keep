# Defines helper functions to be used in the Session views

module SessionsHelper

	# Stores cookie for user passed as parameter, and stores visitor
	# in variable that holds current user
	def sign_in(user)
		cookies.permanent.signed[:remember_token] = [user.id, user.salt]
		current_user = user
	end
	
	# Stores current user in an instance variable
	def current_user=(user)
		@current_user = user
	end
	
	# Sets the variable which stores the current user to the user
	# corresponding to the remember token, but only if the instance
	# variable which stores the current user is undefined
	def current_user
		@current_user ||= user_from_remember_token
	end
	
	# Checks to see if the user passed as a parameter is the user currently
	# signed in
	def current_user?(user)
		user == current_user
	end
	
	# Checks to see if the visitor is signed in
	def signed_in?
		!current_user.nil?
	end
	
	# Signs the current user out, deleting the cookie with the user's remember token
	def sign_out
		cookies.delete(:remember_token)
		current_user = nil
	end
	
	# Uses a Sessions helper method to redirect the user to the sign-in page
	# if the visitor is not signed in
	def authenticate
		deny_access unless signed_in?
	end
	
	# Stores visitor's current URL path, redirects to the sign-in page, and 
	# tells the visitor to sign in to view the page.
	def deny_access
		store_location
		redirect_to signin_path, :notice => "Please sign in to access this page."
	end
	
	# Redirects visitor back to the requested URL if exists, or some default
	# value otherwise
	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		clear_return_to
	end
	
	private
	
		# Stores current URL of visitor
		def store_location
			session[:return_to] = request.fullpath
		end
		
		# Clears value of stored location
		def clear_return_to
			session[:return_to] = nil
		end
		
		# Gets users associated with the remember token
		def user_from_remember_token
			User.authenticate_with_salt(*remember_token)
		end
		
		# Returns cookie for the remember token, or nil otherwise
		def remember_token
			cookies.signed[:remember_token] || [nil, nil]
		end
end
