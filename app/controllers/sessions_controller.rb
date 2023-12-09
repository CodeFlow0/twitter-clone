class SessionsController < ApplicationController
  def create
    @user = User.find_by(username: params[:user][:username])

    if @user && @user.password == params[:user][:password]
      @session = @user.sessions.create
      cookies.signed[:twitter_session_token] = @session.token
      render json: { success: true }
    else
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
  end

  def authenticated
    token = cookies.signed[:twitter_session_token]
    session = Session.find_by(token: token)
    current_user = session.user if session

    if current_user
      render json: { authenticated: true, username: current_user.username }
    else
      render json: { authenticated: false }, status: :unauthorized
    end
  end

  def destroy
    @session = Session.find_by(token: cookies.signed[:twitter_session_token])

    if @session
      @session.destroy
      cookies.delete(:twitter_session_token)
      render json: { message: 'Logged out successfully' }
    else
      render json: { error: 'Session not found' }, status: :not_found
    end
  end
end
