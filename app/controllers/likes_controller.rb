class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @on = @post.likes.create(user: current_user)
    redirect_to post_path(@post)
  end

  def destroy
    @post = Post.find(params[:post_id])
    @post.likes.find(params[:id]).destroy
    redirect_to post_path(@post)
  end
end