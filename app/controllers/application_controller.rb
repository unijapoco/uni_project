class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def schedule
    @response = RestClient.get 'https://app.oddsapi.io/api/v1/odds?apikey=9a68c4a0-3629-11ea-8515-43fe73a2e3fb&sport=soccer'
    render "/schedule"
  end

  protected

  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
