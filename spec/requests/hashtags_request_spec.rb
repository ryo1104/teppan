require 'rails_helper'

RSpec.describe Hashtags::NetasController, type: :request do
  let(:user_create) { create(:user) }

  describe 'GET #index' do
    before do
      @user = user_create
      @topic1 = create(:topic, :with_user)
      @topic2 = create(:topic, :with_user)
      @neta1 = create(:neta, :with_user, topic: @topic1)
      @neta2 = create(:neta, :with_user, topic: @topic1)
      @neta3 = create(:neta, :with_user, topic: @topic1)
      @neta4 = create(:neta, :with_user, topic: @topic2)
      @neta5 = create(:neta, :with_user, topic: @topic2)
      @hashtag1 = create(:hashtag, hashname: 'hashtag1')
      @hashtag2 = create(:hashtag, hashname: 'hashtag2')
      @hashtag3 = create(:hashtag, hashname: 'hashtag3')
      @hashtag4 = create(:hashtag, hashname: 'hashtag4')
      create(:hashtag_neta, neta_id: @neta1.id, hashtag_id: @hashtag1.id)
      create(:hashtag_neta, neta_id: @neta1.id, hashtag_id: @hashtag2.id)
      create(:hashtag_neta, neta_id: @neta2.id, hashtag_id: @hashtag3.id)
      create(:hashtag_neta, neta_id: @neta3.id, hashtag_id: @hashtag4.id)
      create(:hashtag_neta, neta_id: @neta3.id, hashtag_id: @hashtag1.id)
      create(:hashtag_neta, neta_id: @neta4.id, hashtag_id: @hashtag1.id)
      create(:hashtag_neta, neta_id: @neta4.id, hashtag_id: @hashtag3.id)
      create(:hashtag_neta, neta_id: @neta5.id, hashtag_id: @hashtag3.id)
      create(:hashtag_neta, neta_id: @neta5.id, hashtag_id: @hashtag4.id)
    end
    context 'as a guest' do
      it 'returns a 200 status code' do
        get hashtags_netas_url, params: { keyword: 'hashtag1' }
        expect(response).to have_http_status('200')
      end
      it 'searches netas containing hashtags' do
        get hashtags_netas_url, params: { keyword: 'hashtag3' }
        expect(assigns(:netas)).to match_array([@neta2, @neta4, @neta5])
      end
    end
    context 'as a signed in user' do
      before do
        sign_in @user
      end
      it 'returns a 200 status code' do
        get hashtags_netas_url, params: { keyword: 'hashtag2' }
        expect(response).to have_http_status('200')
      end
      it 'searches netas containing hashtags' do
        get hashtags_netas_url, params: { keyword: 'hashtag4' }
        expect(assigns(:netas)).to match_array([@neta3, @neta5])
      end
      it 'adds hashtag hit' do
        expect do
          get hashtags_netas_url, params: { keyword: 'hashtag3' }
        end.
          to change(HashtagHit, :count).by(1)
      end
    end
  end
end
