require 'rails_helper'

RSpec.describe TopController, type: :request do
  describe 'GET #index' do
    it 'responds successfully' do
      get root_url
      expect(response).to have_http_status('200')
    end
    it 'renders the :index template' do
      get root_url
      expect(response.body).to include 'あなたのその鉄板ネタ、売れるかも？'
    end
  end
end
