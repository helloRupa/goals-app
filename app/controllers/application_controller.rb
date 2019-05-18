class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    User.find_by_session_token(session[:session_token])
  end

  def login_user!(user)
    session[:session_token] = user.reset_session_token!
  end

  def logged_in?
    !current_user.nil?
  end

  def not_logged_in
    return if logged_in?
    redirect_to new_session_url
  end

  def already_logged_in
    return unless logged_in?
    redirect_to users_url
  end
end
