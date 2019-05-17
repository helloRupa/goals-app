require 'spec_helper'
require 'rails_helper'
require_relative '../support/feature_helper'
require_relative 'feature_examples'

include FeatureHelper

feature 'main navigation' do
  User.destroy_all

  before(:each) do
    visit new_goal_url
  end

  it_behaves_like 'header and nav'
end

feature 'adding a goal' do
  before(:each) do
    login_as(User.last)
    visit new_goal_url
  end

  feature 'a goal can be public or private' do
    scenario 'there is a checkbox for choosing the status' do
      expect(page).to have_css('input#private[type="checkbox"]')
    end
  end

  feature 'a goal can be complete or in progress' do
    scenario 'there is a checkbox for choosing the status' do
      expect(page).to have_css('input#completed[type="checkbox"]')
    end
  end

  feature 'with valid data' do
    scenario 'it creates the goal' do
      title = 'My testy test'
      body = 'OOOOOhhhh look at this'
      add_goal(title, body)
      visit goal_url(Goal.last)
      expect(page).to have_content(title)
      expect(page).to have_content(body)
    end
  end

  feature 'with invalid data' do
    scenario 'it displays errors' do
      title = nil
      body = 'OOOOOhhhh look at this'
      add_goal(title, body)
      expect(page).to have_css('div.error')
    end
  end
end