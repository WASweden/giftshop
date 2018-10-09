class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  respond_to :html, :json

  def mixpanel
    @mixpanel ||= Mixpanel::Tracker.new(Rails.application.secrets.mixpanel_token)
  end

  before_action :authenticate if Rails.env.staging?

  protected

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == 'wateraid' && password == 'kollegorna123'
    end
  end
end
