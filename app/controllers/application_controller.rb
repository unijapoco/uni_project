class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def schedule
    require "json"
    require "time"
    @response = JSON.parse(RestClient.get('https://app.oddsapi.io/api/v1/odds?apikey=9a68c4a0-3629-11ea-8515-43fe73a2e3fb&sport=soccer'))
    @response.each { |m| m['event']['start_time'] = Time.parse(m['event']['start_time']) }
    @response.select! { |m| m['event']['start_time'] > Time.now }
    @response.select! { |m| m['event']['start_time'] - Time.now < 60 * 60 * 24 * 2 }
    @response.select! { |m| m['sites']['1x2'].key? 'bet365' }
    @response.sort! { |x,y| x['event']['start_time'] <=> y['event']['start_time'] }
    render "/schedule"
  end

  def rankings
    render "/rankings"
  end

  def feed
    if user_signed_in? and (params[:source] == "followed" or params[:source].nil?) and current_user.following.count > 0
      @followed = true
      @content = []
      current_user.following.each { |u| @content << u.tips + u.posts }
    else
      @followed = false
      @content = Tip.all + Post.all
    end
    render "/feed"
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render nothing: true, status: :not_found }
      format.html { redirect_to "", notice: exception.message, status: :not_found }
      format.js   { render nothing: true, status: :not_found }
    end
  end

  protected

  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
