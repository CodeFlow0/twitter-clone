class SessionsController < ApplicationController
  def create
    @user = User.find_by(username: params[:user][:username])
    
    if @user && @user.authenticate(params[:user][:password])
      @session = @user.sessions.create
      cookies.permanent[:twitter_session_token] = @session.token
      render json: { message: 'Logged in successfully' }
    else
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
  end

  def authenticated
    token = cookies[:twitter_session_token]
    puts "Token being decoded: #{token}"
  
    if current_user
      render json: { authenticated: true }
    else
      render json: { authenticated: false }, status: :unauthorized
    end
  end  

  def destroy
    @session = Session.find_by(token: cookies[:twitter_session_token])

    if @session
      @session.destroy
      cookies.delete(:twitter_session_token)
      render json: { message: 'Logged out successfully' }
    else
      render json: { error: 'Session not found' }, status: :not_found
    end
  end
end
