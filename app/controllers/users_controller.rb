# This class contains all the actions for views
# that are part of the User model
require 'sms_fu'
class UsersController < ApplicationController
	
	# Limits which users can access certain actions and when
	before_filter :authenticate, :only => [:index, :edit, :update, :destroy, :requests]
	before_filter :correct_user, :only => [:edit, :update, :requests]
	before_filter :admin_user, 	 :only => :destroy
  
  # This action defines the view which lists a logged-in visitor's contacts,
  # specifying the page's title and pulling all of the visitor's contacts
  # out of the Relationships table, so that they can be paginated.
  def index
	@title = "My Contacts"
	@users = []
	contacteds = Relationship.where("accessed_id = ? AND accepted = ?", current_user.id, true).paginate(:page => params[:page])
	contactors = Relationship.where("accessor_id = ? AND accepted = ?", current_user.id, true).paginate(:page => params[:page])
	contacteds.each do |contacted|
		@users.push(User.find_by_id(contacted.accessor_id))
	end
	contactors.each do |contactor|
		@users.push(User.find_by_id(contactor.accessed_id))
	end
	
	@results = @users.paginate(:page => params[:page])
  end
  
  # This action defines the view which shows a user's profile, specifying the
  # title, and only displaying the contact information on the page if the 
  # visitor has been granted access to view that user's contact information
  # or if it's the visitor's own profile.
  def show
    @user = User.find(params[:id])
	@cuser = current_user
	@visible = Relationship.where("accessed_id = ? AND accessor_id = ? AND accepted = ?", @user.id, @cuser.id, true).first || Relationship.where("accessed_id = ? AND accessor_id = ? AND accepted = ?", @cuser.id, @user.id, true).first || (@cuser.id == @user.id)
	@title = "#{@user.first_name} #{@user.last_name}"
  end
  
  # This action defines the view which allows a visitor to sign up on the
  # website, specifying the page's title and creating a new instance of 
  # the User model
  def new
	@user = User.new
	@title = "Sign up"
  end
  
  # This action saves the new user according to the fields that the 
  # visitor filled in on the sign-up page.  If the save is successful,
  # a welcome message flashes, and the user is redirected to his or
  # her profile page.  Otherwise, the page is re-rendered and the 
  # password field is cleared.
  def create
	@user = User.new(params[:user])
	
	if @user.save
		sign_in @user
		UserMailer.welcome_email(@user).deliver
		flash[:success] = "Welcome to g8keep!"
		redirect_to @user
	else
		@title = "Sign up"
		@user.password = nil
		@user.password_confirmation = nil
		render 'new'
	end
  end
  
  # This action defines the view which allows a user to edit his or her
  # contact information, specifying the title and the user by his or her id.
  def edit
	@user = User.find(params[:id])
	@title = "Edit user"
  end
  
  # This action updates a user's attributes based on the fields that the
  # user filled in on the "edit user" view.  If the update is successful,
  # a success message is flashed and the user is redirected to his or her
  # profile.  Otherwise, the "edit user" view is re-rendered.
  def update
	@user = User.find(params[:id])
	if @user.update_attributes(params[:user])
		flash[:success] = "Profile updated."
		redirect_to @user
	else
		@title = "Edit user"
		render 'edit'
	end
  end
  
  # This action destroys a user from the Users table, finding the user
  # by the given id, flashing a message that the user was destroyed,
  # and then redirecting the user to the path for all users
  def destroy
	User.find(params[:id]).destroy
	flash[:success] = "User destroyed."
	redirect_to users_path
  end
  
  # This action defines the view which displays a user's open requests,
  # specifying the title of the page, and finding all of the instances
  # in the Relationships table in which the current user's id matches the
  # field for the id of the user being accessed.  
  def requests
	@title = "Gate Requests"
	@user = User.find(params[:id])
	@requests = Relationship.where(:accessed_id => params[:id], :accepted => false)
	render 'requests'
  end
  
  def information
	user = User.find(params[:request_id])
	UserMailer.text_information(user, current_user).deliver
	redirect_to user_path(current_user)
  end
  
  # This action updates the accepted attribute of a Relationship instance to true
  # if the current user accepts a pending contact information request.
  def accept
	Relationship.where(:accessed_id => params[:id], :accessor_id => params[:request_id]).first.update_attribute(:accepted, true)
	redirect_to(requests_user_path(current_user))
  end
  
  # This action destroys a Relationship instance if the current user rejects a pending contact
  # information request.
  def reject
	Relationship.where(:accessed_id => params[:id], :accessor_id => params[:request_id]).first.destroy
	redirect_to(requests_user_path(current_user))
  end
  
  private
  
	# Checks if the id of the current user matches the id of the user whose
	# page is being requested.
	def correct_user
		@user = User.find(params[:id])
		redirect_to(root_path) unless current_user?(@user)
	end
	
	# Checks if the current user is an administrator
	def admin_user
		redirect_to(root_path) unless current_user.admin?
	end

end