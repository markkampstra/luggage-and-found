class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def authenticate
    redirect_to(new_user_session_path, alert: 'Access denied, please log in') and return unless current_user
  end
end
