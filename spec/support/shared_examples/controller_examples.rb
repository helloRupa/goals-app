# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'new examples' do |class_name, obj_name|
  describe 'GET #new' do
    it 'renders the new template successfully' do
      get :new
      expect(response).to have_http_status(200)
      expect(response).to render_template(:new)
    end

    it "creates an instance of #{class_name}" do
      get :new
      expect(assigns(obj_name)).to be_a(class_name)
    end
  end
end

RSpec.shared_examples 'invalid create examples' do
  it 'renders the new template' do
    expect(response).to render_template(:new)
  end

  it 'renders errors' do
    expect(flash[:errors]).to be_present
  end
end

RSpec.shared_examples 'valid create examples' do |class_name, _url|
  it "redirects to the #{class_name} show page" do
    expect(response).to redirect_to(ur)
  end
end

RSpec.shared_examples 'valid show examples' do |class_name|
  it 'renders the show template' do
    get :show, params: { id: class_name.last.id }
    expect(response).to render_template(:show)
  end
end

RSpec.shared_examples 'invalid show examples' do
  context 'if item does not exist' do
    it 'redirects to the index page' do
      get :show, params: { id: -1 }
      expect(response).to redirect_to(users_url)
    end
  end
end
