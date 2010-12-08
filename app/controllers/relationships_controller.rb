# This controller contains the actions for the
# Relationship model

class RelationshipsController < ApplicationController
  
  # This authenticates the user before the website
  # executes any methods in this controller
  before_filter :authenticate

  # This action creates a new instance of the Relationship model,
  # first finding the user who is being accessed, storing the
  # newly created Relationship instance in the Relationships table, and then
  # redirect the site visitor back to the profile of the requested
  # user.
  def create
    @user = User.find(params[:relationship][:accessed_id])
    current_user.access!(@user)
	redirect_to @user
	
  end

  # This action destroys an instance of the Relationship model,
  # first finding the user who was being accessed, deleting the
  # existing Relationship instance from the Relationship table, 
  # and then redirecting the visitor back to the profile of the 
  # formerly accessed user.
  def destroy
    @user = Relationship.find(params[:id]).accessed
    current_user.unaccess!(@user)
	redirect_to @user
  end
end
