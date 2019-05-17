require 'spec_helper'
require 'rails_helper'
require_relative '../support/feature_helper'
require_relative 'feature_examples'

include FeatureHelper

feature 'main navigation' do
  it_behaves_like 'header and nav'
end

feature 'main content' do
  username = 'bunson'

  before(:all) do
    register_as(username)
  end

  before(:each) do
    login_as(User.last)
    visit users_url
  end

  scenario 'it contains a list of all users' do
    users = User.pluck(:username)
    users.each do |username|
      within(:css, 'main') { expect(page).to have_content(username) }
    end
  end

  scenario 'each username is a link to its show page' do
    users = User.pluck(:username)
    users.each do |username|
      within(:css, 'main') do
        visit users_url
        click_on(username)
        expect(current_url).to eq(user_url(User.find_by_username(username)))
      end
    end
  end
end
