module ControllerHelper
  REFERRER = 'referrer'

  def login_user
    User.destroy_all
    User.create!(username: 'champ', password: 'password')
    session[:session_token] = User.last.session_token
  end

  def create_goal
    Goal.create!(title: 'title', body: 'body', user_id: User.last.id)
  end

  def create_referrer
    request.env['HTTP_REFERER'] = REFERRER
  end
end