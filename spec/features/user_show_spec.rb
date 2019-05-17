require 'spec_helper'
require 'rails_helper'
require_relative '../support/feature_helper'
require_relative 'feature_examples'

include FeatureHelper

feature 'main navigation' do
  User.destroy_all

  before(:each) do
    visit user_url(User.last)
  end

  it_behaves_like 'header and nav'
end

feature 'user profile' do
  def create_test_goals(id)
    create_goal(id, 'Test Goal 1', true, true)
    create_goal(id, 'Test Goal 2', false, false)
  end

  before(:each) do
    login_as(User.last)
  end

  feature 'when the user is on their own page' do
    before(:each) do
      visit user_url(User.last)
    end

    scenario 'they can see all of their goals, including private' do
      create_test_goals(User.last.id)
      visit user_url(User.last)

      User.last.goals.each do |goal|
        expect(page).to have_link(goal.title)
      end
    end

    scenario 'they can see a delete button for each goal' do
      create_test_goals(User.last.id)
      visit user_url(User.last)
      goal_num = User.last.goals.length

      expect(page).to have_button('Delete').exactly(goal_num).times
    end
  end

  feature 'when the user is on another user\'s page' do
    let(:user) { create_user('darko') }

    before(:each) do
      create_test_goals(user.id)
      visit user_url(user)
    end

    scenario 'they can only see public goals' do
      user.goals.each do |goal|
        unless goal.private
          expect(page).to have_link(goal.title)
        else
          expect(page).to_not have_link(goal.title)
        end
      end
    end

    scenario 'there is no delete button on each goal' do
      expect(page).to_not have_button('Delete')
    end    
  end

  feature 'when on any user page' do
    before(:each) do
      visit user_url(User.first)
    end

    scenario 'the username is displayed in a h1' do
      within(:css, 'main h1') { expect(page).to have_content(User.first.username) }
    end

    scenario 'a user can leave a comment' do
      comment_content = 'Look at this!'
      leave_comment(comment_content)
      visit user_url(User.first)
      within(:css, 'section#comments') { expect(page).to have_content(comment_content) }
    end
  end
end