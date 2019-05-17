require 'spec_helper'
require 'rails_helper'
require_relative '../support/feature_helper'
require_relative 'feature_examples'

include FeatureHelper

feature 'main navigation' do
  User.destroy_all

  before(:each) do
    create_goal(User.first.id, 'title', false, false)
    visit edit_goal_url(Goal.last)
  end

  it_behaves_like 'header and nav'
end

feature 'edit a goal' do
  feature 'it display\'s the goal\'s data' do
    title = 'My Testing Title'

    before(:each) do
      login_as(User.last)
      create_goal(User.last.id, title, true, true)
      visit edit_goal_url(Goal.last)
    end

    scenario 'the title is displayed inside the title field' do
      expect(page).to have_css("input[value='#{title}']")
    end

    scenario 'the body is displayed inside the body field' do
      within(:css, 'textarea') { expect(page).to have_content('Testing') }
    end

    scenario 'the private checkbox is checked when the goal is private' do
      checkbox = find('#private')
      expect(checkbox.checked?).to be(true)
    end

    scenario 'the completed checkbox is checked when the goal is complete' do
      checkbox = find('#completed')
      expect(checkbox.checked?).to be(true)
    end

    scenario 'the private checkbox is not checked when the goal is public' do
      create_goal(User.last.id, title, false, false)
      visit edit_goal_url(Goal.last)
      checkbox = find('#private')
      expect(checkbox.checked?).to be(false)
    end

    scenario 'the completed checkbox is not checked when the goal is not complete' do
      create_goal(User.last.id, title, false, false)
      visit edit_goal_url(Goal.last)
      checkbox = find('#completed')
      expect(checkbox.checked?).to be(false)
    end
  end

  feature 'with invalid data' do
    before(:each) do
      login_as(User.last)
      create_goal(User.last.id, title, true, true)
      visit edit_goal_url(Goal.last)
      fill_in 'title', with: nil
      click_button 'Save'
    end

    scenario 'it should display errors' do
      expect(page).to have_css('div.error')
    end

    scenario 'it should remain on the edit page' do
      expect(page).to have_content('Edit Goal')
    end
  end

  feature 'with valid data' do
    title = 'My New Title Yay'

    before(:each) do
      login_as(User.last)
      create_goal(User.last.id, title, true, true)
      visit edit_goal_url(Goal.last)
      fill_in 'title', with: title
      click_button 'Save'
    end

    scenario 'it should display the updated goal' do
      expect(current_url).to eq(goal_url(Goal.last))
      expect(page).to have_content(title)
    end
  end
end