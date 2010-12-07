class UsersController < ApplicationController
	before_filter :authenticate, :only => [:index, :edit, :update, :destroy, :requests]
	before_filter :correct_user, :only => [:edit, :update, :requests]
	before_filter :admin_user, 	 :only => :destroy
  
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
  
  def show
    @user = User.find(params[:id])
	@cuser = current_user
	@visible = Relationship.where("accessed_id = ? AND accessor_id = ? AND accepted = ?", @user.id, @cuser.id, true).first || Relationship.where("accessed_id = ? AND accessor_id = ? AND accepted = ?", @cuser.id, @user.id, true).first || (@cuser.id == @user.id)
	@title = "#{@user.first_name} #{@user.last_name}"
  end
  
  def new
	@user = User.new
	@title = "Sign up"
  end
  
  def create
	@user = User.new(params[:user])
	if @user.save
		sign_in @user
		flash[:success] = "Welcome to g8keep!"
		redirect_to @user
	else
		@title = "Sign up"
		@user.password = nil
		@user.password_confirmation = nil
		render 'new'
	end
  end
  
  def edit
	@user = User.find(params[:id])
	@title = "Edit user"
  end
  
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
  
  def destroy
	User.find(params[:id]).destroy
	flash[:success] = "User destroyed."
	redirect_to users_path
  end
  
  def accessing
	@title = "Open Gates"
	@user = User.find(params[:id])
	@users = @user.accessing.paginate(:page => params[:page])
	render 'show_access'
  end
  
  def accessors
    @title = "Open Gates"
	@user = User.find(params[:id])
	@users = @user.accessors.paginate(:page => params[:page])
	render 'show_access'
  end
  
  def requests
	@title = "Gate Requests"
	@user = User.find(params[:id])
	@requests = Relationship.where(:accessed_id => params[:id], :accepted => false)
	render 'requests'
  end
  
  def accept
	Relationship.where(:accessed_id => params[:id], :accessor_id => params[:request_id]).first.update_attribute(:accepted, true)
	redirect_to(requests_user_path(current_user))
  end
  
  def reject
	Relationship.where(:accessed_id => params[:id], :accessor_id => params[:request_id]).first.destroy
	redirect_to(requests_user_path(current_user))
  end
  
  def search
	@title = "Search Results"
  end
  
  private
  
	def authenticate
		deny_access unless signed_in?
	end
	
	def correct_user
		@user = User.find(params[:id])
		redirect_to(root_path) unless current_user?(@user)
	end
	
	def admin_user
		redirect_to(root_path) unless current_user.admin?
	end

end