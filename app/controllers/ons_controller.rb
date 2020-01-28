class OnsController < ApplicationController
  before_action :authenticate_user!

  def create
    @tip = Tip.find(params[:tip_id])
    begin
      @on = @tip.ons.create(user: current_user)
      redirect_to tip_path(@tip)
    rescue ActiveRecord::RecordNotUnique
      render 'tips/new'
    end
  end

  def destroy
    @tip = Tip.find(params[:tip_id])
    begin
      @tip.ons.find(params[:id]).destroy
      redirect_to tip_path(@tip)
    rescue ActiveRecord::RecordNotFound
      render 'tips/new'
    end
  end
end