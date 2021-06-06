require 'rails_helper'

RSpec.describe NetasController, type: :request do
  let(:user_create)         { create(:user) }
  let(:topic_create)        { create(:topic, :with_user) }
  let(:neta_create)         { create(:neta, :with_user, topic: topic_create) }
  let(:private_neta_create) { create(:neta, :with_user, topic: topic_create, private_flag: true) }
  let(:review_create)       { create(:review, neta: neta_create) }
  let(:neta_attributes)     { attributes_for(:neta) }
  let(:neta_list_create)    { create_list(:neta, 5, user: user_create, topic: topic_create) }
  let(:hashtag_list_create) { create_list(:hashtag, 15, :with_random_hit_count, :with_random_neta_count) }
  let(:pageview_list_create) { create_list(:pageview, 3, pageviewable: neta_create, user: user_create) }

  describe 'GET #new' do
    subject { get new_topic_neta_url(@topic.id) }

    context 'as a signed in user' do
      before do
        @user = user_create
        sign_in @user
        @topic = topic_create
      end
      context 'and premium user' do
        before do
          allow(@user).to receive(:premium_qualified).and_return(true)
        end
        it 'displays form field for value content' do
          subject
          expect(response.body).to include '有料部分'
        end
        it 'returns a 200 status code' do
          subject
          expect(response).to have_http_status('200')
        end
      end
      context 'but not premium user' do
        it 'does not display form field for value content' do
          subject
          expect(response.body).to_not include '有料部分'
        end
        it 'returns a 200 status code' do
          subject
          expect(response).to have_http_status('200')
        end
      end
    end

    context 'as a guest' do
      before do
        @topic = topic_create
      end
      it 'returns a 302 status code' do
        subject
        expect(response).to have_http_status('302')
      end
      it 'redirects to the sign-in page' do
        subject
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe 'POST #create' do
    subject { post topic_netas_url(@topic.id), params: { neta: { title: @attributes[:title], content: @attributes[:content], price: @attributes[:price], tags: @hashtags } } }

    context 'as a signed in user' do
      before do
        @user = user_create
        sign_in @user
        @topic = topic_create
        @attributes = neta_attributes
        @hashtags = 'タグ1Aa,試験用タグ2,タグ３'
      end
      context 'and data is valid' do
        it 'creates a neta' do
          expect do
            subject
          end.to change(Neta, :count).by(1)
        end
        it 'adds hashtags associated to neta' do
          expect do
            subject
          end.to change(HashtagNeta, :count).by(3)
        end
        it 'redirects to neta#show' do
          subject
          neta = Neta.last
          expect(response).to redirect_to neta_url(neta.id)
        end
        it 'returns a 302 status code' do
          subject
          expect(response).to have_http_status('302')
        end
      end
      context 'and data is invalid' do
        it 'displays error message when neta is invalid' do
          @attributes[:title] = nil
          subject
          expect(response.body).to include 'error-message'
        end
        it 'displays error message when hashtag is invalid' do
          @hashtags = 'tag1, tag2, tag3, tag4, tag5, tag6, tag7, tag8, tag9, tag10, tag11'
          subject
          expect(response.body).to include 'error-message'
        end
        it 'returns a 200 status code' do
          @attributes[:title] = nil
          subject
          expect(response).to have_http_status('200')
        end
      end
      context 'when exception during saving record' do
        before do
          allow_any_instance_of(Neta).to receive(:add_hashtags).and_raise(ActiveRecord::RecordNotSaved)
        end
        it 'rolls back transaction' do
          expect do
            subject
          end.to change(Neta, :count).by(0)
        end
      end
    end
    context 'as a guest' do
      before do
        @topic = topic_create
        @attributes = neta_attributes
        @hashtags = 'tag1, tag2, tag3'
      end
      it 'redirects to user sign-in page' do
        subject
        expect(response).to redirect_to new_user_session_url
      end
      it 'returns a 302 status code' do
        subject
        expect(response).to have_http_status('302')
      end
    end
  end

  describe 'GET #show' do
    subject { get neta_url(@neta.id) }

    context 'as a signed in user' do
      before do
        @user = user_create
        sign_in @user
      end
      context 'and non-owner' do
        context 'when private flag is true' do
          before do
            @neta_owner = create(:user)
            @neta = create(:neta, user: @neta_owner, topic: topic_create, title: 'テストネタのタイトル', private_flag: true)
          end
          it 'displays block message' do
            subject
            expect(response.body).to include 'このネタは非公開に設定されています。'
          end
          it 'returns a 200 status code' do
            subject
            expect(response).to have_http_status('200')
          end
        end
        context 'when private flag is false' do
          before do
            @neta = create(:neta, :with_user, topic: topic_create, private_flag: false)
          end
          it 'shows free content' do
            subject
            expect(response.body).to include 'ネタテスト　無料部分'
          end
          it 'shows hashtags' do
            @hashtag = create(:hashtag, hashname: 'なんかのハッシュタグ')
            create(:hashtag_neta, neta_id: @neta.id, hashtag_id: @hashtag.id)
            subject
            expect(response.body).to include 'なんかのハッシュタグ'
          end
          it 'adds pageview' do
            expect do
              subject
            end.to change(Pageview, :count).by(1)
          end
          context 'and price is zero' do
            before do
              @neta = create(:neta, :with_user, topic: topic_create, private_flag: false, price: 0)
            end
            it 'shows free content' do
              subject
              expect(response.body).to include 'ネタテスト　無料部分'
            end
          end
          context 'and price is non-zero' do
            before do
              @neta_owner = create(:user)
              @neta = create(:neta, :with_valuecontent, user: @neta_owner, topic: topic_create, private_flag: false, price: 100)
              allow_any_instance_of(Neta).to receive(:for_sale).and_return(true)
            end
            it 'shows free content' do
              subject
              expect(response.body).to include 'ネタテスト　無料部分'
            end
            context 'and trade exists' do
              before do
                @trade = create(:trade, buyer_id: @user.id, seller_id: @neta_owner.id, tradeable_type: 'Neta', tradeable_id: @neta.id)
              end
              it 'shows traded price' do
                subject
                expect(response.body).to include '100円で購入済'
              end
              context 'but my review does not exist' do
                it 'shows review form' do
                  subject
                  expect(response.body).to include '評価して下さい'
                end
              end
              context 'and my review exists' do
                before do
                  @myreview = create(:review, neta: @neta, user: @user)
                  some_user = create(:user)
                  @somereview = create(:review, neta: @neta, user: some_user)
                end
                it 'shows list of all reviews' do
                  subject
                  expect(response.body).to include 'レビュー(2件)'
                end
              end
            end
            context 'and no trade exists' do
              context 'but is for sale' do
                it 'shows sale price' do
                  subject
                  expect(response.body).to include 'これより先は有料コンテンツです'
                end
                it 'shows active bookmark button' do
                  subject
                  expect(response.body).to include 'bookmark_buttons'
                end
              end
              context 'but is not for sale' do
                before do
                  allow_any_instance_of(Neta).to receive(:for_sale).and_return(false)
                end
                it 'shows message saying not for sale' do
                  subject
                  expect(response.body).to include '現在は販売されておりません'
                end
              end
            end
          end
        end
      end
      context 'and owner' do
        context 'when private flag is true' do
          context 'and price is zero' do
            before do
              @neta = create(:neta, :with_valuecontent, user: @user, topic: topic_create, title: 'テストネタのタイトル', private_flag: true, price: 0)
            end
            it 'shows free content' do
              subject
              expect(response.body).to include 'ネタテスト　無料部分'
            end
          end
          context 'and price is non-zero' do
            before do
              @neta = create(:neta, :with_valuecontent, user: @user, topic: topic_create, title: 'テストネタのタイトル', private_flag: true, price: 200)
            end
            it 'shows value content' do
              subject
              expect(response.body).to include 'ネタテスト　有料部分'
            end
          end
          it 'shows price' do
            @neta = create(:neta, :with_valuecontent, user: @user, topic: topic_create, title: 'テストネタのタイトル', private_flag: true, price: 200)
            subject
            expect(response.body).to include '価格：200円'
          end
          it 'shows edit button' do
            @neta = create(:neta, :with_valuecontent, user: @user, topic: topic_create, title: 'テストネタのタイトル', private_flag: true)
            subject
            expect(response.body).to include '編集'
          end
        end
        context 'when private flag is false' do
          context 'and price is zero' do
            before do
              @neta = create(:neta, :with_valuecontent, user: @user, topic: topic_create, title: 'テストネタのタイトル', private_flag: true, price: 0)
            end
            it 'shows free content' do
              subject
              expect(response.body).to include 'ネタテスト　無料部分'
            end
          end
          context 'and price is non-zero' do
            before do
              @neta = create(:neta, :with_valuecontent, user: @user, topic: topic_create, title: 'テストネタのタイトル', private_flag: true, price: 200)
            end
            it 'shows value content' do
              subject
              expect(response.body).to include 'ネタテスト　有料部分'
            end
          end
          it 'shows price' do
            @neta = create(:neta, :with_valuecontent, user: @user, topic: topic_create, title: 'テストネタのタイトル', private_flag: true, price: 200)
            subject
            expect(response.body).to include '価格：200円'
          end
          it 'shows edit button' do
            @neta = create(:neta, :with_valuecontent, user: @user, topic: topic_create, title: 'テストネタのタイトル', private_flag: true)
            subject
            expect(response.body).to include '編集'
          end
        end
        context 'reviews exist' do
          before do
            @neta = create(:neta, :with_valuecontent, user: @user, topic: topic_create, title: 'テストネタのタイトル', private_flag: false, price: 0)
            some_user1 = create(:user)
            some_user2 = create(:user)
            create(:review, neta: @neta, user: some_user1)
            create(:review, neta: @neta, user: some_user2)
          end
          it 'shows list of all reviews' do
            subject
            expect(response.body).to include 'レビュー(2件)'
          end
        end
        context 'reviews do not exist' do
          before do
            @neta = create(:neta, :with_valuecontent, user: @user, topic: topic_create, title: 'テストネタのタイトル', private_flag: true, price: 100)
          end
          it 'shows message saying blank' do
            subject
            expect(response.body).to include 'レビューはありません'
          end
        end
      end
    end
    context 'as a guest' do
      before do
        @neta = neta_create
      end

      subject { get neta_url(@neta.id) }

      it 'returns a 302 status code' do
        subject
        expect(response).to have_http_status('302')
      end
      it 'redirects to the sign-in page' do
        subject
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe 'GET #edit' do
    subject { get edit_neta_url(@neta.id) }

    context 'as a signed in user' do
      before do
        @user = user_create
        sign_in @user
      end
      context 'as a neta owner' do
        before do
          @neta = create(:neta, :with_valuecontent, user: @user, topic: topic_create, title: 'テストネタのタイトル', private_flag: true, price: 0)
        end
        context 'and neta is editable' do
          before do
            allow_any_instance_of(Neta).to receive(:editable).and_return(true)
          end
          it 'returns a 200 status code' do
            subject
            expect(response).to have_http_status('200')
          end
          it 'displays the edit form' do
            subject
            expect(response.body).to include 'ネタ（編集）'
          end
          context 'and user is premium user' do
            before do
              allow(@user).to receive(:premium_qualified).and_return(true)
            end
            it 'can set a non-zero price' do
              subject
              expect(response.body).to_not include '有料投稿はビジネスアカウント登録が必要です'
            end
          end
          context 'but user is not premium user' do
            before do
              allow(@user).to receive(:premium_qualified).and_return(false)
            end
            it 'cannot set a non-zero price' do
              subject
              expect(response.body).to include '有料投稿はビジネスアカウント登録が必要です'
            end
          end
        end
        context 'but neta is not editable' do
          before do
            allow_any_instance_of(Neta).to receive(:editable).and_return(false)
          end
          it 'returns a 302 status code' do
            subject
            expect(response).to have_http_status('302')
          end
          it 'redirects to neta#show' do
            subject
            expect(response).to redirect_to neta_path(@neta.id)
          end
        end
      end
      context 'not as a neta owner' do
        before do
          @neta = neta_create
          allow_any_instance_of(Neta).to receive(:owner).and_return(false)
        end
        it 'returns a 302 status code' do
          subject
          expect(response).to have_http_status('302')
        end
        it 'redirects to neta#show' do
          subject
          expect(response).to redirect_to neta_path(@neta.id)
        end
      end
    end
    context 'as a guest' do
      before do
        @neta = neta_create
      end
      it 'returns a 302 status code' do
        subject
        expect(response).to have_http_status('302')
      end
      it 'redirects to user sign-in page' do
        subject
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe 'PATCH #update' do
    context 'as a signed in user' do
      before do
        @user = user_create
        sign_in @user
        @topic = topic_create
      end
      context 'and data is valid' do
        subject { patch neta_url(@neta.id), params: { neta: { title: @attributes[:title], content: @attributes[:content], price: @attributes[:price], tags: @hashtags } } }

        before do
          @neta = create(:neta, user: @user, topic: @topic)
          @attributes = neta_attributes
          @hashtags = 'tag1,tag2,tag3'
        end
        it 'updates the neta' do
          expect do
            subject
          end.to change(Neta, :count).by(0)
        end
        it 'redirects to show action' do
          subject
          expect(response).to redirect_to neta_path(@neta.id)
        end
      end
      context 'and data is invalid' do
        subject { patch neta_url(@neta.id), params: { neta: { title: @attributes[:title], content: @attributes[:content], price: @attributes[:price], tags: @hashtags } } }

        before do
          @neta = create(:neta, user: @user, topic: @topic)
          @attributes = neta_attributes
          @hashtags = 'tag1, tag2, tag3'
        end
        it 'displays error message when neta is invalid' do
          @attributes[:title] = nil
          subject
          expect(response.body).to include 'error-message'
        end
        it 'displays error message when hashtag is invalid' do
          @hashtags = 'tag1, tag2, tag3, tag4, tag5, tag6, tag7, tag8, tag9, tag10, tag11'
          subject
          expect(response.body).to include 'error-message'
        end
        it 'returns a 200 status code' do
          @attributes[:title] = nil
          subject
          expect(response).to have_http_status('200')
        end
      end
    end

    context 'as a guest' do
      before do
        @user = user_create
        @topic = topic_create
        @neta = create(:neta, user: @user, topic: @topic)
        @attributes = neta_attributes
        @hashtags = 'tag1, tag2, tag3'
      end

      subject { patch neta_url(@neta.id), params: { neta: { title: @attributes[:title], content: @attributes[:content], price: @attributes[:price], tags: @hashtags } } }

      it 'returns a 302 status code' do
        subject
        expect(response).to have_http_status('302')
      end

      it 'redirects to user sign-in page' do
        subject
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe 'DELETE #destroy' do
    subject { delete neta_url(@neta.id) }

    context 'as a signed in user' do
      before do
        @user = user_create
        sign_in @user
      end
      context 'as a neta owner' do
        before do
          @neta = create(:neta, :with_valuecontent, user: @user, topic: topic_create, title: 'テストネタのタイトル', private_flag: true, price: 0)
        end
        it 'deletes the neta' do
          expect do
            subject
          end.to change(Neta, :count).by(-1)
        end
        it 'deletes the hashtag associations with neta (but not the hashtag itself)' do
          hashtag1 = create(:hashtag, hashname: 'tag1')
          create(:hashtag, hashname: 'tag2')
          hashtag3 = create(:hashtag, hashname: 'tag3')
          create(:hashtag_neta, neta: @neta, hashtag: hashtag1)
          create(:hashtag_neta, neta: @neta, hashtag: hashtag3)
          expect do
            subject
          end.to change(HashtagNeta, :count).by(-2)
        end
        it 'redirects to topic' do
          subject
          expect(response).to redirect_to topic_path(@neta.topic_id)
        end
        it 'returns a 302 status code' do
          subject
          expect(response).to have_http_status('302')
        end
        context 'when dependent records exist' do
          before do
            allow_any_instance_of(Neta).to receive(:has_dependents).and_return(true)
          end
          it 'does not delete the neta' do
            expect do
              subject
            end.to change(Neta, :count).by(0)
          end
          it 'redirects back to neta' do
            subject
            expect(response).to redirect_to neta_path(@neta.id)
          end
          it 'returns a 302 status code' do
            subject
            expect(response).to have_http_status('302')
          end
        end
      end
      context 'not as a neta owner' do
        before do
          @another_user = create(:user)
          @neta = create(:neta, :with_valuecontent, user: @another_user, topic: topic_create, title: 'テストネタのタイトル', private_flag: true, price: 0)
        end
        it 'returns a 302 status code' do
          subject
          expect(response).to have_http_status('302')
        end
        it 'redirects back to neta' do
          subject
          expect(response).to redirect_to neta_path(@neta.id)
        end
      end
      context 'when exception during deleting record' do
        before do
          @neta = create(:neta, :with_valuecontent, user: @user, topic: topic_create, title: 'テストネタのタイトル', private_flag: true, price: 0)
          allow_any_instance_of(Neta).to receive(:delete_hashtags).and_raise(ActiveRecord::RecordNotFound)
        end
        it 'rolls back transaction' do
          expect do
            subject
          end.to change(Neta, :count).by(0)
        end
      end
    end
    context 'as a guest' do
      before do
        @neta = neta_create
      end
      it 'returns a 302 status code' do
        subject
        expect(response).to have_http_status('302')
      end
      it 'redirects to user sign-in page' do
        subject
        expect(response).to redirect_to new_user_session_url
      end
    end
  end
end
