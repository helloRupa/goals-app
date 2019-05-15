require 'spec_helper'
require 'rails_helper'

def register_as(username)
  visit new_user_url
  fill_in 'username', with: username
  fill_in 'password', with: "password"
  click_button 'Register'
end

def login_as(user)
  visit new_session_url
  fill_in 'username', with: user.username
  fill_in 'password', with: "password"
  click_button 'Log In'
end

feature 'the signup process' do
  scenario 'has a new user page' do
    visit new_user_url
    expect(page).to have_content('Sign Up')
  end

  feature 'signing up a user' do
    scenario 'displays errors if signup is unsuccessful' do
      register_as(nil)
      expect(page).to have_css('div.error')
    end

    scenario 'shows username on the homepage after signup' do
      register_as('barbar')
      expect(current_url).to eq(user_url(User.find_by_credentials('barbar', 'password')))
      expect(page).to have_content('barbar')
    end
  end
end

feature 'logging in' do
  scenario 'displays errors if login is unsuccessful' do
    login_as(User.new(username: 'nillinson'))
    expect(page).to have_css('div.error')
  end

  scenario 'shows username on the homepage after login' do
    login_as(User.first)
    expect(page).to have_content(User.first.username)
    expect(current_url).to eq(user_url(User.first.id))
  end
end

feature 'logging out' do
  scenario 'begins with a logged out state' do
    visit users_url
    expect(current_url).to eq(new_session_url)
  end

  scenario 'doesn\'t show username on the homepage after logout' do
    login_as(User.first)
    click_on 'Log Out'
    expect(page).to_not have_content(User.first.username)
    expect(current_url).to eq(new_session_url)
  end
end