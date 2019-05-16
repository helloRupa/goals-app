require 'rails_helper'
require_relative '../support/shared_examples/controller_examples'

RSpec.describe UsersController, type: :controller do
  def login
    post :create, params: { user: { username: 'hilbert', password: 'password' } }
  end

  describe 'GET #index' do
    before(:each) do
      login
    end

		it 'renders the index template successfully' do
			get :index
			expect(response).to have_http_status(200)
			expect(response).to render_template(:index)
		end
  end

  it_behaves_like 'new examples', User, :user

  describe 'POST #create' do
    context 'with invalid params' do
      before(:each) do
        post :create, params: { user: { username: 'hilbert', password: '1' } }
      end

      include_examples 'invalid create examples'
    end

    context 'with valid params' do
      before(:each) do
        User.destroy_all
        post :create, params: { user: { username: 'hilbert', password: '12345678' } }
      end

      it 'logs the user in' do
        expect(User.last.session_token).to eq(session[:session_token])
      end

      it 'redirects to the user show page' do
        expect(response).to redirect_to(user_url(User.last))
      end
    end
  end

  describe 'GET #show' do
    before(:each) do
      login
    end

    include_examples "valid show examples", User

    it_behaves_like "invalid show examples"
  end
end
