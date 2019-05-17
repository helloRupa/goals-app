module FeatureHelper
  def register_as(username)
    visit new_user_url
    fill_in 'username', with: username
    fill_in 'password', with: 'password'
    click_button 'Register'
  end
  
  def login_as(user)
    visit new_session_url
    fill_in 'username', with: user.username
    fill_in 'password', with: 'password'
    click_button 'Log In'
  end

  def logout
    click_button 'Log Out'
  end

  def create_user(username)
    User.create!(username: username, password: 'password')
  end

  def create_goal(user_id, title, completed, is_private)
    Goal.create!(user_id: user_id, title: title, body: 'Testing', completed: completed, private: is_private)
  end
end