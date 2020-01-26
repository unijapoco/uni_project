class TipCommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @tip = Tip.find(params[:tip_id])
    @tip_comment = @tip.tip_comments.create(user: current_user, content: params[:tip_comment][:content])
    redirect_to tip_path(@tip)
  end

  def destroy
    @tip = Tip.find(params[:tip_id])
    @tip.tip_comments.find(params[:id]).destroy
    redirect_to tip_path(@tip)
  end
end
