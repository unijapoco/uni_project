class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    begin
      @on = @post.likes.create(user: current_user)
      redirect_to post_path(@post)
    rescue ActiveRecord::RecordNotUnique
      render 'posts/show'
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    begin
      @post.likes.find(params[:id]).destroy
      redirect_to post_path(@post)
    rescue ActiveRecord::RecordNotFound
      render 'posts/show'
    end
  end
end