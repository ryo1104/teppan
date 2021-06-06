require 'rails_helper'

RSpec.describe BookmarksController, type: :request do
  let(:user_create)       { create(:user) }
  let(:topic_create)      { create(:topic, :with_user) }
  let(:neta_create)       { create(:neta, :with_user, topic: topic_create) }

  describe 'POST #create' do
    context 'as a signed in user' do
      before do
        @user = user_create
        sign_in @user
        @topic = topic_create
        @neta = neta_create
      end
      context 'when save succeeds' do
        context 'and Topic is bookmarkable' do
          it 'creates a Bookmarks record' do
            expect do
              post topic_bookmarks_path(@topic.id), xhr: true
            end.to change(Bookmark, :count).by(1)
          end
          it 'user_id of new record is current user' do
            post topic_bookmarks_path(@topic.id), xhr: true
            new_bookmark = Bookmark.last
            expect(new_bookmark.user_id).to eq @user.id
          end
          it 'bookmarkable type of new record is Topic' do
            post topic_bookmarks_path(@topic.id), xhr: true
            new_bookmark = Bookmark.last
            expect(new_bookmark.bookmarkable_type).to eq 'Topic'
          end
          it 'bookmarkable id of new record is topic id' do
            post topic_bookmarks_path(@topic.id), xhr: true
            new_bookmark = Bookmark.last
            expect(new_bookmark.bookmarkable_id).to eq @topic.id
          end
          it 'returns a 200 status code' do
            post topic_bookmarks_path(@topic.id), xhr: true
            expect(response).to have_http_status('200')
          end
        end
        context 'when Neta is bookmarkable' do
          it 'adds record to Bookmark table' do
            expect do
              post neta_bookmarks_path(@neta.id), xhr: true
            end.to change(Bookmark, :count).by(1)
          end
          it 'user_id of new record is current user' do
            post neta_bookmarks_path(@neta.id), xhr: true
            new_bookmark = Bookmark.last
            expect(new_bookmark.user_id).to eq @user.id
          end
          it 'bookmarkable type of new record is Neta' do
            post neta_bookmarks_path(@neta.id), xhr: true
            new_bookmark = Bookmark.last
            expect(new_bookmark.bookmarkable_type).to eq 'Neta'
          end
          it 'bookmarkable id of new record is neta id' do
            post neta_bookmarks_path(@neta.id), xhr: true
            new_bookmark = Bookmark.last
            expect(new_bookmark.bookmarkable_id).to eq @neta.id
          end
          it 'returns a 200 status code' do
            post neta_bookmarks_path(@neta.id), xhr: true
            expect(response).to have_http_status('200')
          end
        end
      end
      context 'when save fails' do
        it 'redirects to user page' do
          allow_any_instance_of(Bookmark).to receive(:save).and_return(false)
          post topic_bookmarks_path(@topic.id), xhr: true
          expect(response).to redirect_to user_url(@user.id)
        end
        it 'returns a 302 status code' do
          allow_any_instance_of(Bookmark).to receive(:save).and_return(false)
          post neta_bookmarks_path(@neta.id), xhr: true
          expect(response).to have_http_status('302')
        end
      end
    end
    context 'as a guest' do
      before do
        @user = user_create
        @topic = topic_create
        @neta = neta_create
      end
      it 'returns a 401 status code' do
        post topic_bookmarks_path(@topic.id), xhr: true
        expect(response).to have_http_status('401')
      end
    end
  end

  describe 'DELETE #destroy', type: :doing do
    context 'as a signed in user' do
      before do
        @user = user_create
        sign_in @user
        @topic = topic_create
        @neta = neta_create
      end
      context 'when destroy succeeds' do
        context 'when Topic is bookmarkable' do
          before do
            @bookmark = Bookmark.create(bookmarkable: @topic, user: @user)
          end
          it 'deletes record from Bookmark table' do
            expect do
              delete topic_bookmark_path(@topic.id, @bookmark.id), xhr: true
            end.to change(Bookmark, :count).by(-1)
          end
          it 'returns a 200 status code' do
            delete topic_bookmark_path(@topic.id, @bookmark.id), xhr: true
            expect(response).to have_http_status('200')
          end
          context 'when current user is not owner of bookmark' do
            before do
              sign_out @user
              @another_user = create(:user)
              sign_in @another_user
            end
            it 'redirects to user' do
              delete topic_bookmark_path(@topic.id, @bookmark.id), xhr: true
              expect(response).to redirect_to user_path(@another_user.id)
            end
            it 'returns a 302 status code' do
              delete topic_bookmark_path(@topic.id, @bookmark.id), xhr: true
              expect(response).to have_http_status('302')
            end
          end
        end
        context 'when Neta is bookmarkable' do
          before do
            @bookmark = Bookmark.create(bookmarkable: @neta, user: @user)
          end
          it 'deletes record from Bookmark table' do
            expect do
              delete neta_bookmark_path(@neta.id, @bookmark.id), xhr: true
            end.to change(Bookmark, :count).by(-1)
          end
          it 'returns a 200 status code' do
            delete neta_bookmark_path(@neta.id, @bookmark.id), xhr: true
            expect(response).to have_http_status('200')
          end
          context 'when current user is not owner of bookmark' do
            before do
              sign_out @user
              @another_user = create(:user)
              sign_in @another_user
            end
            it 'redirects to neta' do
              delete neta_bookmark_path(@neta.id, @bookmark.id), xhr: true
              expect(response).to redirect_to user_path(@another_user.id)
            end
            it 'returns a 302 status code' do
              delete neta_bookmark_path(@neta.id, @bookmark.id), xhr: true
              expect(response).to have_http_status('302')
            end
          end
        end
      end
      context 'when destroy fails' do
        before do
          allow_any_instance_of(Bookmark).to receive(:destroy).and_return(false)
          @bookmark = Bookmark.create(bookmarkable: @topic, user: @user)
        end
        it 'redirects to user page' do
          delete topic_bookmark_path(@topic.id, @bookmark.id), xhr: true
          expect(response).to redirect_to user_url(@user.id)
        end
        it 'returns a 302 status code' do
          delete neta_bookmark_path(@neta.id, @bookmark.id), xhr: true
          expect(response).to have_http_status('302')
        end
      end
    end
    context 'as a guest' do
      before do
        @user = user_create
        @topic = topic_create
        @neta = neta_create
      end
      context 'when Topic is bookmarkable' do
        it 'returns a 401 status code' do
          @bookmark = Bookmark.create(bookmarkable: @topic, user: @user)
          delete topic_bookmark_path(@topic.id, @bookmark.id), xhr: true
          expect(response.status).to eq 401
        end
      end
      context 'when Neta is bookmarkable' do
        it 'returns a 401 status code' do
          @bookmark = Bookmark.create(bookmarkable: @neta, user: @user)
          delete neta_bookmark_path(@neta.id, @bookmark.id), xhr: true
          expect(response.status).to eq 401
        end
      end
    end
  end
end
