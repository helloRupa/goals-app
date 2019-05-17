# frozen_string_literal: true

require 'rails_helper'
require_relative '../support/feature_helper'

RSpec.shared_examples 'header and nav' do
  username = 'bunson'

  before(:all) do
    register_as(username)
  end

  before(:each) do
    login_as(User.last)
    visit users_url
  end

  scenario 'it displays the app name' do
    expect(page).to have_content('Goals App')
  end

  scenario 'the logo is a link to the users page' do
    within(:css, 'header') { click_on('Goals App') }
    expect(current_url).to eq(users_url)
  end

  scenario 'it includes a link to the user\'s show page' do
    within(:css, 'nav') { click_on(username) }
    expect(current_url).to eq(user_url(User.last))
  end

  scenario 'it includes a logout button' do
    expect(page).to have_button('Log Out')
  end
end
