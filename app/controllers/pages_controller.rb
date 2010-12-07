class PagesController < ApplicationController
  def home
	@title = "Home"
  end

  def contact
	@title = "Contact"
  end
  
  def about
	@title = "About"
  end
  
  def help
	@title = "Help"
  end
  
  def results
	@title = "Search Results"
	@users = User.search(params[:search])
  end
  
  def requests
	@title = "Requests"
  end

end
