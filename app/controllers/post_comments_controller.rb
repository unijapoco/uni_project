class PostCommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @post_comment = @post.post_comments.new(user: current_user, content: params[:post_comment][:content])
    if @post_comment.save
      redirect_to @post
    else
      flash[:error] = @post_comment.errors.full_messages.to_sentence
      redirect_to @post
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    begin
      @post_comment = @post.post_comments.find(params[:id])
      authorize! :delete, @post_comment
      @post_comment.destroy
      redirect_to post_path(@post)
    rescue  ActiveRecord::RecordNotFound
      render "posts/show"
    end
  end
end
