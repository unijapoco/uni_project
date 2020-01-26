class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @on = @tip.likes.create(user: current_user)
  end

  def destroy
    @post = Post.find(params[:post_id])
    @post.likes.find(params[:id]).destroy
  end
end