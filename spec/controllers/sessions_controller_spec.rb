require 'rails_helper'
require_relative '../support/shared_examples/controller_examples'

RSpec.describe SessionsController, type: :controller do

  it_behaves_like 'new examples', User, :user

  def login_user(username, password)
    post :create, params: { user: { username: username, password: password } }
  end

  def save_valid_user
    credentials = %w[Frankenstein password]
    User.destroy_all
    User.create(username: credentials[0], password: credentials[1])
    credentials
  end

  describe 'POST #create' do
    context 'with invalid credentials' do
      before(:each) do
        login_user('aaa', '1')
      end

      it 'does not set the session token cookie' do
        expect(session[:session_token]).to be_nil
      end

      it 'renders the new template' do
        expect(response).to render_template(:new)
      end

      it 'provides an error message' do
        expect(flash[:errors]).to be_present
      end
    end

    context 'with valid credentials' do
      before(:each) do
        username, password = save_valid_user
        login_user(username, password)
      end

      it 'logs the user in' do
        expect(session[:session_token]).to eq(User.first.session_token)
      end

      it 'redirects to the user page' do
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(user_url(User.first.id))
      end
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      username, password = save_valid_user
      login_user(username, password)
      delete :destroy, params: { id: User.first.id }
    end

    it 'logs the user out' do
      expect(session[:session_token]).to be_nil
      expect(User.first.session_token).to_not eq(session[:session_token])
    end

    it 'redirects to the new session (login) page' do
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(new_session_url)
    end
  end
end
