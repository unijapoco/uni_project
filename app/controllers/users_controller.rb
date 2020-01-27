class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @stats = @user.stats
    @content = @user.tips + @user.posts
  end

  def stats
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

  def update_extra
    current_user.desc = params[:user][:desc]
    current_user.notifications_email = params[:user][:notifications_email]
    current_user.save
    redirect_to user_path(current_user)
  end

  def following
    @users = User.find(params[:id]).following
  end

  def followers
    @users = User.find(params[:id]).followers
  end
end