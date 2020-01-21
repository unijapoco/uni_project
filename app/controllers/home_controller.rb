class HomeController < ApplicationController
  def index
    @tips = Tip.all
  end
end
