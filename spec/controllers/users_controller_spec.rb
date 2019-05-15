require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #index' do
		it 'renders the index template successfully' do
			get :index
			expect(response).to have_http_status(200)
			expect(response).to render_template(:index)
		end
  end
  
  describe 'GET #new' do
    it 'renders the new template successfully' do
      get :new
      expect(response).to have_http_status(200)
      expect(response).to render_template(:new)
    end

    it 'creates an instance of User' do
      get :new
      expect(assigns(:user)).to be_a(User)
    end
  end

  describe 'POST #create' do
    context 'with invalid params' do
      def invalid_user
        post :create, params: { user: { username: 'hilbert', password: '1' } }
      end

      it 'renders the new template' do
        invalid_user
        expect(response).to render_template(:new)
      end

      it 'renders errors' do
        invalid_user
        expect(flash[:errors]).to be_present
      end
    end

    context 'with valid params' do
      it 'logs the user in' do
        User.destroy_all
        post :create, params: { user: { username: 'hilbert', password: '12345678' } }
        expect(User.last.session_token).to eq(session[:session_token])
      end

      it 'redirects to the user show page' do
        User.destroy_all
        post :create, params: { user: { username: 'hilbert', password: '12345678' } }
        expect(response).to redirect_to(user_url(User.last))
      end
    end
  end

  describe 'GET #show' do
    it 'renders the show template' do
      User.create(username: 'happy', password: 'password')
      get :show, params: { id: User.last.id }
      expect(response).to render_template(:show)
    end

    context 'if user does not exist' do
      it 'redirects to the index page' do
        get :show, params: { id: -1 }
        expect(response).to redirect_to(users_url)
      end
    end
  end
end
