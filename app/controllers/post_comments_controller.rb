class PostCommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @post_comment = @post.post_comments.create(user: current_user, content: params[:post_comment][:content])
    redirect_to post_path(@post)
  end

  def destroy
    @post = Post.find(params[:post_id])
    authorize! :delete, @post
    @post.post_comments.find(params[:id]).destroy
    redirect_to post_path(@post)
  end
end
