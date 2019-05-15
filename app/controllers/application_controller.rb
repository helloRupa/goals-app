class ApplicationController < ActionController::Base
  def login_user!(user)
    session_token = user.reset_session_token!
    session[:session_token] = session_token
  end
end
