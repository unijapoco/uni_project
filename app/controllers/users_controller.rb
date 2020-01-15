class UsersController < ApplicationController
  def index
    @users = User.all
    print @users
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
    redirect_to "/users" #doesn't work as expected no idea why
  end
end