class TipsController < ApplicationController
  before_action :authenticate_user!

  def new
    @tip = Tip.new
  end

  def create
    @user = current_user
    @tip = @user.tips.new(tip_params)

    if @tip.save
      redirect_to @tip
    else
      render 'new'
    end
  end

  def show
    @tip = Tip.find(params[:id])
  end

  private
    def tip_params
      params.require(:tip).permit(:desc, :odds, :stake, :info)
    end
end
