require 'rails_helper'

RSpec.describe CommentsController, type: :request do
  let(:user_create)       { create(:user) }
  let(:topic_create)      { create(:topic, :with_user) }
  let(:neta_create)       { create(:neta, :with_user, topic: topic_create) }

  describe 'POST #create' do
    context 'as a signed in user' do
      before do
        @user = user_create
        sign_in @user
      end
      context 'when save succeeds' do
        context 'when Topic is commentable' do
          before do
            @topic = topic_create
          end
          it 'adds record to Comments' do
            expect do
              post topic_comments_path(@topic.id), params: { comment: { text: 'test comment' } }
            end.
              to change(Comment, :count).by(1)
          end
          it 'user_id of new record is current user' do
            post topic_comments_path(@topic.id), params: { comment: { text: 'test comment' } }
            new_comment = Comment.last
            expect(new_comment.user_id).to eq @user.id
          end
          it 'commentable type of new record is Topic' do
            post topic_comments_path(@topic.id), params: { comment: { text: 'test comment' } }
            new_comment = Comment.last
            expect(new_comment.commentable_type).to eq 'Topic'
          end
          it 'commentable id of new record is topic id' do
            post topic_comments_path(@topic.id), params: { comment: { text: 'test comment' } }
            new_comment = Comment.last
            expect(new_comment.commentable_id).to eq @topic.id
          end
          it 'redirects to topic#show' do
            post topic_comments_path(@topic.id), params: { comment: { text: 'test comment' } }
            expect(response).to redirect_to topic_path(@topic.id)
          end
          it 'returns a 302 status code' do
            post topic_comments_path(@topic.id), params: { comment: { text: 'test comment' } }
            expect(response).to have_http_status('302')
          end
        end
      end
      context 'when save fails' do
        before do
          @topic = topic_create
          allow_any_instance_of(Comment).to receive(:save).and_return(false)
        end
        it 'redirects to user page' do
          post topic_comments_path(@topic.id), params: { comment: { text: 'test comment' } }
          expect(response).to redirect_to user_url(@user.id)
        end
        it 'returns a 302 status code' do
          post topic_comments_path(@topic.id), params: { comment: { text: 'test comment' } }
          expect(response).to have_http_status('302')
        end
        it 'displays alert message' do
          post topic_comments_path(@topic.id), params: { comment: { text: 'test comment' } }
          expect(flash[:alert]).to include 'コメントを投稿できませんでした。'
        end
      end
    end
    context 'as a guest' do
      context 'when Topic is commentable' do
        before do
          @topic = topic_create
        end
        it 'returns a 302 status code' do
          post topic_comments_path(@topic.id), params: { comment: { text: 'test comment' } }
          expect(response).to have_http_status('302')
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'as a signed in user' do
      before do
        @user = user_create
        sign_in @user
      end
      context 'when destroy succeeds' do
        context 'when Topic is commentable' do
          before do
            @topic = topic_create
            @comment = create(:comment, user: @user, commentable: @topic)
          end
          it 'populates deleted flag with date' do
            delete topic_comment_path(@topic.id, @comment.id)
            @comment.reload
            expect(@comment.deleted_at).to_not eq nil
          end
          it 'redirects to review#show' do
            delete topic_comment_path(@topic.id, @comment.id)
            expect(response).to redirect_to topic_path(@topic.id)
          end
          it 'returns a 302 status code' do
            delete topic_comment_path(@topic.id, @comment.id)
            expect(response).to have_http_status('302')
          end
          context 'when current user is not owner of interest' do
            before do
              sign_out @user
              @another_user = create(:user)
              sign_in @another_user
            end
            it 'redirects to user page' do
              delete topic_comment_path(@topic.id, @comment.id)
              expect(response).to redirect_to user_url(@another_user.id)
            end
            it 'returns a 302 status code' do
              delete topic_comment_path(@topic.id, @comment.id)
              expect(response).to have_http_status('302')
            end
          end
        end
      end
      context 'when destroy fails' do
        before do
          allow_any_instance_of(Comment).to receive(:update).and_return(false)
          @topic = topic_create
          @comment = create(:comment, user: @user, commentable: @topic)
        end
        it 'redirects to user page' do
          delete topic_comment_path(@topic.id, @comment.id)
          expect(response).to redirect_to user_url(@user.id)
        end
        it 'returns a 302 status code' do
          delete topic_comment_path(@topic.id, @comment.id)
          expect(response).to have_http_status('302')
        end
        it 'displays alert message' do
          delete topic_comment_path(@topic.id, @comment.id)
          expect(flash[:alert]).to include 'コメントを削除できませんでした。'
        end
      end
    end
  end
  context 'as a guest' do
    context 'when Topic is commentable' do
      before do
        @user = user_create
        @topic = topic_create
        @comment = create(:comment, user: @user, commentable: @topic)
      end
      it 'redirects to user sign-in page' do
        delete topic_comment_path(@topic.id, @comment.id)
        expect(response).to redirect_to new_user_session_url
      end
      it 'returns a 302 status code' do
        delete topic_comment_path(@topic.id, @comment.id)
        expect(response).to have_http_status('302')
      end
      it 'displays alert message' do
        delete topic_comment_path(@topic.id, @comment.id)
        expect(flash[:alert]).to include 'これより先はログイン又はユーザー登録が必要です。'
      end
    end
  end
end
