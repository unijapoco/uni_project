class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def schedule
    @response = OddsAPI::Schedule.get
    render "/schedule"
  end

  def rankings
    @users = User.all.select { |u| u.tips.settled.count >= 5 }
    @stats = []
    @users.each { |u| @stats << u.stats }
    @stats.sort_by! { |s| s[:yield] }.reverse!
    render "/rankings"
  end

  def feed
    if user_signed_in? and (params[:source] == "followed" or params[:source].nil?) and current_user.following.count > 0
      @followed = true
      @content = []
      current_user.following.each { |u| @content += u.tips + u.posts }
    else
      @followed = false
      @content = Tip.all + Post.all
    end
    @content.sort_by! { |c| c.created_at }.reverse!
    render "/feed"
  end

  def search_user
    @users = User.where("username like ?", "%"+params[:q]+"%")
    render "/search_user"
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

module OddsAPI
  class Schedule
    def self.get
      require "json"
      require "time"

      url = "https://app.oddsapi.io/api/v1/odds?apikey=" + Rails.application.credentials.oddsapi[:key] + "&sport=soccer"
      begin
        response = JSON.parse(RestClient.get(url))
      rescue StandardError
        return nil
      end
      response.each { |m| m['event']['start_time'] = Time.parse(m['event']['start_time']) }
      response.select! { |m| m['event']['start_time'] > Time.now }
      response.select! { |m| m['event']['start_time'] - Time.now < 60 * 60 * 24 * 2 }
      response.select! { |m| m['sites']['1x2'].key? 'bet365' }
      response.sort! { |x,y| x['event']['start_time'] <=> y['event']['start_time'] }
      response
    end
  end
end
