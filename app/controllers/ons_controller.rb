class OnsController < ApplicationController
  before_action :authenticate_user!

  def create
    @tip = Tip.find(params[:tip_id])
    @on = @tip.ons.create(user: current_user)
  end

  def destroy
  end
end