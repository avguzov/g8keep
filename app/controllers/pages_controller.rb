# This controller contains all the actions for views
# that are part of the Pages model

class PagesController < ApplicationController

  # This action defines the view for the home screen
  # and specifies its displayed title
  def home
	@title = "Home"
  end

  # This action defines the view for the contact page
  # and specifies its title
  def contact
	@title = "Contact"
  end
  
  # This action defines the view for the about page
  # and specifies its title
  def about
	@title = "About"
  end
  
  # This action defines the view for the help page
  # and specifies its title
  def help
	@title = "Help"
  end
  
  # This action defines the view for the page which displays
  # the results from a user's search.  It specifies the page's
  # title and stores the results of the search in an instance
  # variable.
  def results
	@title = "Search Results"
	@users = User.search(params[:search])
  end
  
  # This action defines the view for the page which displays
  # the current user's pending access requests from other users
  # and specifies its title
  def requests
	@title = "Requests"
  end
  
  # This action defines the view for the page which displays
  # the valid service providers that users may have for their
  # cell phones, and specifies the page's title
  def providers
	@title = "Valid Service Providers"
  end

end
