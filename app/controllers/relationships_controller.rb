class RelationshipsController < ApplicationController
  before_filter :authenticate

  def create
    @user = User.find(params[:relationship][:accessed_id])
    current_user.access!(@user)
	respond_to do |format|
		format.html { redirect_to @user }
		format.js
	end
  end

  def destroy
    @user = Relationship.find(params[:id]).accessed
    current_user.unaccess!(@user)
	respond_to do |format|
		format.html { redirect_to @user}
		format.js
	end
  end
end
