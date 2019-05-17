# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'
require_relative '../support/feature_helper'
require_relative 'feature_examples'

include FeatureHelper

feature 'display goal' do
  User.destroy_all

  before(:all) do
    create_user('darko')
    create_goal(User.first.id, 'My Public Incomplete Goal', false, false)
    create_goal(User.first.id, 'My Private Complete Goal', true, true)
  end

  feature 'main navigation' do
    before(:each) do
      visit goal_url(Goal.last)
    end

    it_behaves_like 'header and nav'
  end

  feature 'page content' do
    let(:goal) { Goal.last }
    let(:user) { User.find_by_username('darko') }

    before(:each) do
      login_as(user)
      visit goal_url(goal)
    end

    scenario 'it displays the title of the goal' do
      within(:css, 'main h1') { expect(page).to have_content(goal.title) }
    end

    scenario 'it displays a link to the user who owns the goal' do
      within(:css, 'main') { expect(page).to have_link(goal.user.username) }
    end

    scenario 'when the goal is incomplete, the status is In Progress' do
      create_goal(user.id, 'My Public Incomplete Goal', false, false)
      visit goal_url(Goal.last)
      within(:css, 'main') { expect(page).to have_content('In Progress') }
    end

    scenario 'when the goal is completed, the status is Complete' do
      create_goal(user.id, 'My Public Complete Goal', true, false)
      visit goal_url(Goal.last)
      within(:css, 'main') { expect(page).to have_content('Complete') }
    end

    scenario 'when the goal is not private, visibility says Public' do
      create_goal(user.id, 'My Public Incomplete Goal', false, false)
      visit goal_url(Goal.last)
      within(:css, 'main') { expect(page).to have_content('Public') }
    end

    scenario 'when the goal is private, visibility says Private' do
      create_goal(user.id, 'My Private Incomplete Goal', true, true)
      visit goal_url(Goal.last)
      within(:css, 'main') { expect(page).to have_content('Private') }
    end

    feature 'when viewing own goal' do
      scenario 'the Cheer button is not visible' do
        create_goal(user.id, 'My Private Incomplete Goal', true, true)
        visit goal_url(Goal.last)
        expect(page).to_not have_button('Cheer')
      end

      scenario 'the Edit Goal link is visible' do
        create_goal(user.id, 'My Private Incomplete Goal', true, true)
        visit goal_url(Goal.last)
        expect(page).to have_link('Edit Goal')
      end
    end

    feature 'when viewing another user\'s goal' do
      before(:each) do
        create_user('tankman')
        create_goal(User.last.id, 'Tank Goal', true, false)
        visit goal_url(Goal.last)
      end

      scenario 'the Cheer button is visible' do
        expect(page).to have_button('Cheer')
      end

      scenario 'the Edit Goal link is not visible' do
        expect(page).to_not have_link('Edit Goal')
      end
    end
  end
end
