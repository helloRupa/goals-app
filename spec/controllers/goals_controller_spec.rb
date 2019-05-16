require 'rails_helper'

RSpec.describe GoalsController, type: :controller do
  def clear_and_make_user
    Goal.destroy_all
    User.destroy_all
    User.create(username: 'champ', password: 'password')
  end

  def create_goal(user_id)
    Goal.create(user_id: user_id, title: 'title', body: 'body')
  end

  it_behaves_like 'new examples', Goal, :goal
  
  describe 'POST #create' do
    context 'with invalid params' do
      before(:each) do
        post :create, params: { goal: { user_id: '5' } }
      end

      include_examples 'invalid create examples'
    end

    context 'with valid params' do
      it 'redirects to the goal show page' do
        user = clear_and_make_user
        post :create, params: { goal: { user_id: user.id, title: 'title', body: 'body' } }
        expect(response).to redirect_to(goal_url(Goal.last))
      end
    end
  end

  describe 'GET #show' do
    before(:each) do
      user = clear_and_make_user
      create_goal(user.id)
    end

    include_examples "valid show examples", Goal

    it_behaves_like "invalid show examples"
  end

  describe 'GET #edit' do
    before(:each) do
      user = clear_and_make_user
      create_goal(user.id)
    end

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
    before(:each) do
      user = clear_and_make_user
      create_goal(user.id)
    end

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
    before(:each) do
      user = clear_and_make_user
      create_goal(user.id)
    end

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
