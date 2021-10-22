require 'rails_helper'

RSpec.describe 'HashtagAutocompletes', type: :request do
  describe 'GET #index' do
    subject { get hashtags_netas_url, params: { keyword: @keyword } }

    context 'if hashtag already exists' do
      before do
        @target_tag = create(:hashtag, hashname: '何かのハッシュタグ')
        @keyword = '何かのハッシュタグ'
      end
      context 'as a signed in user' do
        before do
          @user = create(:user)
          sign_in @user
        end
        it 'hit count increases by 1' do
          expect do
            subject
          end.
            to change(HashtagHit, :count).by(1)
        end
        it 'returns a 200 status code' do
          subject
          expect(response).to have_http_status('200')
        end
      end
      context 'as a guest' do
        it 'hit count is unchanged' do
          expect do
            subject
          end.
            to change(HashtagHit, :count).by(0)
        end
      end
      it 'returns a 200 status code' do
        subject
        expect(response).to have_http_status('200')
      end
    end
    context 'if hashtag does not exist' do
      before do
        @target_tag = create(:hashtag, hashname: '何かのハッシュタグ')
        @keyword = '何か'
      end
      it 'hit count is unchanged' do
        expect do
          subject
        end.
          to change(HashtagHit, :count).by(0)
      end
      it 'returns a 200 status code' do
        subject
        expect(response).to have_http_status('200')
      end
    end
  end
end
