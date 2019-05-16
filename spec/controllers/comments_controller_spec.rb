require 'rails_helper'
require_relative '../support/shared_examples/controller_examples'
require_relative '../support/controller_helper'

RSpec.describe CommentsController, type: :controller do
  include ControllerHelper

  before(:each) do
    login_user
    create_goal
    create_referrer
  end

  describe 'POST #create' do
    context 'with invalid params' do
      before(:each) do
        post :create, params: { comment: { body: nil } }
      end

      it 'does not add the comment to the database' do
        expect(Comment.last).to be_nil
      end

      it 'renders errors' do
        expect(flash[:errors]).to be_present
      end

      it 'issues a redirect' do
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(request.referrer)
      end
    end

    context 'with valid params' do
      body = 'body for testing'

      before(:each) do
        post :create, params: { comment: { body: body, commentable_type: 'Goal', commentable_id: Goal.last.id } }
      end

      it 'redirects to the referring page' do
        expect(response).to redirect_to(request.referrer)
      end

      it 'adds the comment to the database' do
        expect(Comment.last.body).to eq(body)
        expect(Comment.last.user_id).to eq(User.last.id)
        expect(Comment.last.commentable_id).to eq(Goal.last.id)
      end
    end
  end
end
