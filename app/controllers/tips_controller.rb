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

  def index
    @tips = Tip.all
  end

  def destroy
    @tip = Tip.find(params[:id])
    @tip.destroy

    redirect_to tips_path
  end

  def settle
    @tip = Tip.find(params[:id])
    @tip.result = params[:tip][:result]
    @tip.save
    redirect_to @tip
  end

  def amend
    @tip = Tip.find(params[:id])
    authorize! :amend, @tip
    @tip.result = params[:tip][:result]
    @tip.save
    redirect_to @tip
  end

  def edit_info
    @tip = Tip.find(params[:id])
    @tip.info = params[:tip][:info]
    @tip.save
    redirect_to @tip
  end

  private
    def tip_params
      params.require(:tip).permit(:desc, :odds, :stake, :info)
    end
end
