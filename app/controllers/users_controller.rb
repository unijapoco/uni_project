class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def update_role
    @user = User.find(params[:id])
    authorize! :update_role, @user
    @user.janitor = params["user"]["janitor"] == "1"
    @user.admin = params["user"]["admin"] == "1"
    @user.save
    redirect_to action: "index"
  end
end