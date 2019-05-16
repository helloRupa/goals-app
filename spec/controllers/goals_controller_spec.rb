require 'rails_helper'
require_relative '../support/shared_examples/controller_examples'
require_relative '../support/controller_helper'

RSpec.describe GoalsController, type: :controller do
  include ControllerHelper

  before(:each) do
    login_user
  end

  it_behaves_like 'new examples', Goal, :goal
  
  describe 'POST #create' do
    context 'with invalid params' do
      before(:each) do
        post :create, params: { goal: { title: nil } }
      end

      include_examples 'invalid create examples'
    end

    context 'with valid params' do
      it 'redirects to the goal show page' do
        post :create, params: { goal: { title: 'title', body: 'body' } }
        expect(response).to redirect_to(goal_url(Goal.last))
      end
    end
  end

  before(:each) do
    create_goal
  end

  describe 'GET #show' do
    include_examples "valid show examples", Goal

    it_behaves_like "invalid show examples"
  end

  describe 'GET #edit' do
    it 'renders the edit template successfully' do
      get :edit, params: { id: Goal.last.id }
      expect(response).to have_http_status(200)
      expect(response).to render_template(:edit)
    end

    context 'if the goal does not exist' do
      it 'renders the users page' do
        get :edit, params: { id: -1 }
        expect(response).to redirect_to(users_url)
      end
    end
  end

  describe 'PATCH #update' do
    context 'when update is successful' do
      it 'redirects to the goal\'s show page' do
        patch :update, params: { id: Goal.last.id, goal: { title: 'New Title', body: 'New Body' } }
        expect(response).to redirect_to(goal_url(Goal.last))
      end

      it 'updates the goal' do
        title = Goal.last.title + 'hiya'
        patch :update, params: { id: Goal.last.id, goal: { title: title } }
        expect(Goal.last.title).to eq(title)
      end
    end

    context 'when params are invalid' do
      it 'renders the edit template' do
        patch :update, params: { id: Goal.last.id, goal: { title: nil } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'removes the goal from the database' do
      goal_id = Goal.last.id
      delete :destroy, params: { id: goal_id }
      expect(Goal.find_by_id(goal_id)).to be_nil
    end

    it 'redirects to the goal author\'s page' do
      delete :destroy, params: { id: Goal.last.id }
      expect(response).to redirect_to(user_url(User.last))
    end
  end
end
