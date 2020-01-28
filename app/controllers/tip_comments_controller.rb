class TipCommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @tip = Tip.find(params[:tip_id])
    @tip_comment = @tip.tip_comments.new(user: current_user, content: params[:tip_comment][:content])
    if @tip_comment.save
      redirect_to @tip
    else
      flash[:error] = @tip_comment.errors.full_messages.to_sentence
      redirect_to @tip
    end
  end

  def destroy
    @tip = Tip.find(params[:tip_id])
    begin
      @tip_comment = @tip.tip_comments.find(params[:id])
      authorize! :delete, @tip_comment
      @tip_comment.destroy
      redirect_to tip_path(@tip)
    rescue  ActiveRecord::RecordNotFound
      render "tips/show"
    end
  end
end
