class UsersController < ApplicationController
  def index
    @users = User.all
    print @users
  end

  def show
    @user = User.find(params[:id])
  end
end