class PostsController < ApplicationController
  before_action :authenticate_user!, except: [ :show ]

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    print @post
    if @post.save
      redirect_to @post
    else
      render "new"
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def destroy
  end

  private
  def post_params
    params.require(:post).permit(:content)
  end
end