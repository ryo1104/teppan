require 'rails_helper'

RSpec.describe ViolationsController, type: :controller do
  let(:user_create) { FactoryBot.create(:user) }
  render_views

  describe 'GET #new' do
    context 'as an authenticated user' do
      before do
        @violater = FactoryBot.create(:user)
        @user = FactoryBot.create(:user)
        sign_in @user
      end
      it 'populates @user' do
        get :new, params: { user_id: @violater.id }
        expect(assigns(:user)).to eq @violater
      end
      it 'renders the :new template' do
        get :new, params: { user_id: @violater.id }
        expect(assigns(:user)).to render_template :new
      end
      it 'returns a 200 status code' do
        get :new, params: { user_id: @violater.id }
        expect(response).to have_http_status('200')
      end
    end

    context 'as a guest' do
      before do
        @violater = FactoryBot.create(:user)
      end
      it 'redirects to the sign-in page' do
        get :new, params: { user_id: @violater.id }
        expect(response).to redirect_to '/users/sign_in'
      end
      it 'returns a 302 status code' do
        get :new, params: { user_id: @violater.id }
        expect(response).to have_http_status('302')
      end
    end
  end

  describe 'POST #create' do
    context 'as an authenticated user' do
      before do
        @user = user_create
        sign_in @user
        @violater = FactoryBot.create(:user)
      end
      it 'populates @violater' do
        post :create, params: { user_id: @violater.id, violation: { text: '', block: 1 } }
        expect(assigns(:violater)).to eq @violater
      end
      it 'creates a violation' do
        expect do
          post :create, params: { user_id: @violater.id, violation: { text: '', block: 1 } }
        end.to change(Violation, :count).by(1)
      end
      it 'deletes follows by reporter when exists' do
        @follow = FactoryBot.create(:follow, user_id: @violater.id, follower_id: @user.id)
        expect  do
          post :create, params: { user_id: @violater.id, violation: { text: '', block: 1 } }
        end.to change(Follow, :count).by(-1)
      end
      it 'redirects to violater user page' do
        post :create, params: { user_id: @violater.id, violation: { text: '', block: 1 } }
        expect(response).to redirect_to user_path(@violater.id)
      end
      it 'returns a 302 status code' do
        post :create, params: { user_id: @violater.id, violation: { text: '', block: 1 } }
        expect(response).to have_http_status('302')
      end

      context 'when violation report by the user already exists' do
        before do
          FactoryBot.create(:violation, user: @violater, reporter_id: @user.id)
        end
        it "redirects to reporter's user page" do
          post :create, params: { user_id: @violater.id, violation: { text: '', block: 1 } }
          expect(response).to redirect_to user_path(@user.id)
        end
        it 'returns a 302 status code' do
          post :create, params: { user_id: @violater.id, violation: { text: '', block: 1 } }
          expect(response).to have_http_status('302')
        end
      end
    end
  end
end
