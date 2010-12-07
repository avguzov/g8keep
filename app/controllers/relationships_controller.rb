class RelationshipsController < ApplicationController
  before_filter :authenticate

  def create
    @user = User.find(params[:relationship][:accessed_id])
    current_user.access!(@user)
	redirect_to @user
	
  end

  def destroy
    @user = Relationship.find(params[:id]).accessed
    current_user.unaccess!(@user)
	redirect_to @user
  end
end
