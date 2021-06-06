require 'rails_helper'

RSpec.describe 'User Session', type: :request do
  let(:user_create) { create(:user) }

  describe 'GET #new' do
    subject { get new_user_session_url }
    context 'as a signed in user' do
      before do
        @user = user_create
        sign_in @user
      end
      it 'returns a 302 status code' do
        subject
        expect(response).to have_http_status('302')
      end
      it 'redirects to root path' do
        subject
        expect(response).to redirect_to root_path
      end
    end
    context 'as a guest' do
      it 'returns a 200 status code' do
        subject
        expect(response).to have_http_status('200')
      end
      it 'displays sign in screen' do
        subject
        expect(response.body).to include 'ログイン'
      end
    end
  end

  describe 'POST #create' do
    context 'if email is not present in params' do
      it 'returns a 302 status code' do
        post user_session_url, params: { user: { email: nil, password: nil } }
        expect(response).to have_http_status('302')
      end
      it 'redirects to login page' do
        post user_session_url, params: { user: { email: nil, password: nil } }
        expect(response).to redirect_to new_user_session_url
      end
    end
    context 'if user record cannot be found' do
      it 'returns a 302 status code' do
        post user_session_url, params: { user: { email: 'aaaaa@hoge.com', password: nil } }
        expect(response).to have_http_status('302')
      end
      it 'redirects to login page' do
        post user_session_url, params: { user: { email: 'aaaaa@hoge.com', password: nil } }
        expect(response).to redirect_to new_user_session_url
      end
    end
    context 'if user is in unregistered status' do
      before do
        @user = create(:user, email: 'bbbbb@hoge.com', unregistered: true)
      end
      it 'returns a 302 status code' do
        post user_session_url, params: { user: { email: 'bbbbb@hoge.com', password: nil } }
        expect(response).to have_http_status('302')
      end
      it 'redirects to login page' do
        post user_session_url, params: { user: { email: 'bbbbb@hoge.com', password: nil } }
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe 'DELETE #destroy' do
    subject { delete destroy_user_session_url }
    context 'as a signed in user' do
      before do
        @user = user_create
        sign_in @user
      end
      it 'returns a 302 status code' do
        subject
        expect(response).to have_http_status('302')
      end
      it 'redirects to root path' do
        subject
        expect(response).to redirect_to root_path
      end
    end
    context 'as a guest' do
      it 'returns a 302 status code' do
        subject
        expect(response).to have_http_status('302')
      end
      it 'redirects to login page' do
        subject
        expect(response.body).to redirect_to root_path
      end
    end
  end
end
# RSpec.describe SessionsController, type: :controller do
#   context 'for Twitter' do
#     subject { get :create, params: { provider: 'twitter' } }
#     before { request.env['omniauth.auth'] = twitter_mock }

#     it 'finds Authorization if exists' do
#       auth = create(:authorization, :with_user, provider: 'twitter', uid: '123456')
#       subject
#       expect(assigns(:auth)).to eq auth
#     end

#     it 'creates Authorization if it does not exist' do
#       expect { subject }.to change(Authorization, :count).by(1)
#     end

#     it 'populates @auth_ret with [true, @auth]' do
#       subject
#       auth_obj = Authorization.last
#       expect(assigns(:auth_ret)).to eq [true, auth_obj]
#     end

#     it 'populates @user' do
#       subject
#       some_user = User.last
#       expect(assigns(:user)).to eq some_user
#     end

#     it 'signs in and redirects to root' do
#       subject
#       expect(response).to redirect_to root_path
#     end
#   end

#   context 'for YahooJP' do
#     subject { get :create, params: { provider: 'yahoojp' } }
#     before { request.env['omniauth.auth'] = yahoojp_mock }

#     it 'finds Authorization if exists' do
#       auth = create(:authorization, :with_user, provider: 'yahoojp', uid: '123456')
#       subject
#       expect(assigns(:auth)).to eq auth
#     end

#     it 'creates Authorization if it does not exist' do
#       expect { subject }.to change(Authorization, :count).by(1)
#     end

#     it 'populates @auth_ret with [true, @auth]' do
#       subject
#       auth_obj = Authorization.last
#       expect(assigns(:auth_ret)).to eq [true, auth_obj]
#     end

#     it 'populates @user' do
#       subject
#       some_user = User.last
#       expect(assigns(:user)).to eq some_user
#     end

#     it 'signs in and redirects to root' do
#       subject
#       expect(response).to redirect_to root_path
#     end
#   end

#   context 'for Google' do
#     subject { get :create, params: { provider: 'google_oauth2' } }
#     before { request.env['omniauth.auth'] = google_oauth2_mock }

#     it 'finds Authorization if exists' do
#       auth = create(:authorization, :with_user, provider: 'google_oauth2', uid: '123456')
#       subject
#       expect(assigns(:auth)).to eq auth
#     end

#     it 'creates Authorization if it does not exist' do
#       expect { subject }.to change(Authorization, :count).by(1)
#     end

#     it 'populates @auth_ret with [true, @auth]' do
#       subject
#       auth_obj = Authorization.last
#       expect(assigns(:auth_ret)).to eq [true, auth_obj]
#     end

#     it 'populates @user' do
#       subject
#       some_user = User.last
#       expect(assigns(:user)).to eq some_user
#     end

#     it 'signs in and redirects to root' do
#       subject
#       expect(response).to redirect_to root_path
#     end
#   end

#   context 'when omniauth.auth is empty' do
#     before { request.env['omniauth.auth'] = nil }
#     subject { get :create, params: { provider: 'twitter' } }

#     it 'redirects to root path' do
#       expect(subject).to redirect_to new_user_session_path
#     end

#     it 'flashes alert message' do
#       subject
#       expect(flash[:alert]).to eq 'ユーザー認証に失敗しました。'
#     end

#     it 'writes to Rails logger an error message' do
#       expect(Rails.logger).to receive(:error).with('request.env[omniauth.auth] does not exist')
#       subject
#     end
#   end

#   context 'when failed to create Authorization' do
#     subject { get :create, params: { provider: 'twitter' } }
#     before do
#       request.env['omniauth.auth'] = twitter_mock
#       allow(Authorization).to receive(:find_from_auth).and_return(nil)
#       allow(Authorization).to receive(:create_from_auth).and_return([false, 'some error message'])
#     end

#     it 'redirects to sign in page' do
#       subject
#       expect(response).to redirect_to new_user_session_path
#     end
#     it 'flashes alert message' do
#       subject
#       expect(flash[:alert]).to eq 'ユーザー認証に失敗しました。'
#     end
#     it 'writes to Rails logger an error message' do
#       expect(Rails.logger).to receive(:error).with('Authorization.create_from_auth returned false : some error message')
#       subject
#     end
#   end
# end
