require 'rails_helper'

RSpec.describe TopController, type: :controller do

  describe "GET #index" do
    it "responds successfully" do
      get :index
      expect(response).to have_http_status("200")
    end
    
    it "renders the :index template" do
      get :index
      expect(response).to render_template :index
    end
  end

end