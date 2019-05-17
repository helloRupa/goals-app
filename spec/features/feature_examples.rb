# frozen_string_literal: true

require 'rails_helper'
require_relative '../support/feature_helper'

RSpec.shared_examples 'header and nav' do
  username = 'bunson'

  before(:all) do
    create_user(username)
  end

  before(:each) do
    login_as(User.find_by_username(username))
  end

  scenario 'it displays the app name' do
    within(:css, 'header') { expect(page).to have_content('Goals App') }
  end

  scenario 'the logo is a link to the users page' do
    within(:css, 'header') { click_on('Goals App') }
    expect(current_url).to eq(users_url)
  end

  scenario 'it includes a link to the user\'s show page' do
    within(:css, 'nav') { click_on(username) }
    expect(current_url).to eq(user_url(User.find_by_username(username)))
  end

  scenario 'it includes a logout button' do
    expect(page).to have_button('Log Out')
  end

  scenario 'it includes a link to add a new goal' do
    within(:css, 'nav') { click_on('+') }
    expect(current_url).to eq(new_goal_url)
  end

  scenario 'their remaining cheers are displayed' do
    expect(page).to have_content('Cheers:')
  end
end
