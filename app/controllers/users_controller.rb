class UsersController < ApplicationController
  def index
    redirect_to new_user_session_path unless user_signed_in?
    authorize! :index, current_user
    @users = User.all.order :username
  end

  def show
    @user = User.find(params[:id])
    @stats = @user.stats
    @content = @user.tips + @user.posts
    @content.sort_by! { |c| c.created_at }.reverse!
  end

  def update_extra
    redirect_to new_user_session_path unless user_signed_in?
    authorize! :update_extra, current_user
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

  def admin_delete
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path
  end

  def admin_jani
    @user = User.find(params[:id])
    @user.janitor = true
    @user.save
    redirect_to users_path
  end

  def admin_dejani
    @user = User.find(params[:id])
    @user.janitor = false
    @user.save
    redirect_to users_path
  end

  def admin_admin
    @user = User.find(params[:id])
    @user.admin = true
    @user.save
    redirect_to users_path
  end

  def admin_deadmin
    @user = User.find(params[:id])
    @user.admin = false
    @user.save
    redirect_to users_path
  end
end