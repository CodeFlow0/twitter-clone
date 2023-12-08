class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find_by(id: decoded_user_id)
  end

  def decoded_user_id
    if session[:user_id]
      session[:user_id]
    elsif cookies[:twitter_session_token]
      token = cookies[:twitter_session_token]
      decoded_token = JsonWebToken.decode(token)
      decoded_token[:user_id] if decoded_token
    end
  end
end
