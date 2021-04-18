require 'rails_helper'

RSpec.describe CommentsController, type: :request do
  let(:user_create)       { FactoryBot.create(:user) }
  let(:topic_create)      { FactoryBot.create(:topic, :with_user) }
  let(:neta_create)       { FactoryBot.create(:neta, :with_user, topic: topic_create) }
  let(:review_create)     { FactoryBot.create(:review, :with_user, neta: neta_create) }

  describe 'POST #create' do
    context 'as a signed in user' do
      before do
        @user = user_create
        sign_in @user
      end
      context 'when Review is commentable' do
        before do
          @review = review_create
        end
        it 'populates @commentable' do
          post review_comments_path(@review.id), params: { comment: { text: 'test comment' } }
          expect(assigns(:commentable)).to eq @review
        end
        it 'creates a comment' do
          expect do
            post review_comments_path(@review.id), params: { comment: { text: 'test comment' } }
          end.to change(Comment, :count).by(1)
        end
        it 'user_id of new record is current user' do
          post review_comments_path(@review.id), params: { comment: { text: 'test comment' } }
          new_comment = Comment.last
          expect(new_comment.user_id).to eq @user.id
        end
        it 'commentable type of new record is Review' do
          post review_comments_path(@review.id), params: { comment: { text: 'test comment' } }
          new_comment = Comment.last
          expect(new_comment.commentable_type).to eq 'Review'
        end
        it 'commentable id of new record is review id' do
          post review_comments_path(@review.id), params: { comment: { text: 'test comment' } }
          new_comment = Comment.last
          expect(new_comment.commentable_id).to eq @review.id
        end
        it 'redirects to review#show' do
          post review_comments_path(@review.id), params: { comment: { text: 'test comment' } }
          expect(response).to redirect_to review_path(@review.id)
        end
        it 'returns a 302 status code' do
          post review_comments_path(@review.id), params: { comment: { text: 'test comment' } }
          expect(response).to have_http_status('302')
        end
      end
      context 'when Topic is commentable' do
        before do
          @topic = topic_create
        end
        it 'populates @commentable' do
          post topic_comments_path(@topic.id), params: { comment: { text: 'test comment' } }
          expect(assigns(:commentable)).to eq @topic
        end
        it 'adds record to Comments' do
          expect do
            post topic_comments_path(@topic.id), params: { comment: { text: 'test comment' } }
          end.to change(Comment, :count).by(1)
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
    context 'as a guest' do
      context 'when Review is commentable' do
        before do
          @review = review_create
        end
        it 'returns a 302 status code' do
          post review_comments_path(@review.id), params: { comment: { text: 'test comment' } }
          expect(response).to have_http_status('302')
        end
      end
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
      context 'when Review is commentable' do
        before do
          @review = review_create
          @comment = FactoryBot.create(:comment, user: @user, commentable: @review)
        end
        it 'populates @comment' do
          delete comment_path(@comment.id)
          expect(assigns(:comment)).to eq @comment
        end
        it 'populates @commentable_type as reviews' do
          delete comment_path(@comment.id)
          expect(assigns(:commentable_type)).to eq 'reviews'
        end
        it 'populates @commentable_id with review id' do
          delete comment_path(@comment.id)
          expect(assigns(:commentable_id)).to eq @review.id
        end
        it 'updates text with deleted message' do
          delete comment_path(@comment.id)
          @comment.reload
          expect(@comment.text).to eq '（このコメントは削除されました）'
        end
        it 'redirects to review#show' do
          delete comment_path(@comment.id)
          expect(response).to redirect_to review_path(@review.id)
        end
        it 'returns a 302 status code' do
          delete comment_path(@comment.id)
          expect(response).to have_http_status('302')
        end
        context 'when current user is not owner of interest' do
          before do
            sign_out @user
            @another_user = FactoryBot.create(:user)
            sign_in @another_user
          end
          it 'redirects to review#show' do
            delete comment_path(@comment.id)
            expect(response).to redirect_to review_path(@review.id)
          end
          it 'returns a 302 status code' do
            delete comment_path(@comment.id)
            expect(response).to have_http_status('302')
          end
        end
      end
      context 'when Topic is commentable' do
        before do
          @topic = topic_create
          @comment = FactoryBot.create(:comment, user: @user, commentable: @topic)
        end
        it 'populates @comment' do
          delete topic_comment_path(@topic.id, @comment.id)
          expect(assigns(:comment)).to eq @comment
        end
        it 'populates @commentable_type as topics' do
          delete topic_comment_path(@topic.id, @comment.id)
          expect(assigns(:commentable_type)).to eq 'topics'
        end
        it 'populates @commentable_id with topic id' do
          delete topic_comment_path(@topic.id, @comment.id)
          expect(assigns(:commentable_id)).to eq @topic.id
        end
        it 'updates text with deleted message' do
          delete topic_comment_path(@topic.id, @comment.id)
          @comment.reload
          expect(@comment.text).to eq '（このコメントは削除されました）'
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
            @another_user = FactoryBot.create(:user)
            sign_in @another_user
          end
          it 'redirects to review#show' do
            delete topic_comment_path(@topic.id, @comment.id)
            expect(response).to redirect_to topic_path(@topic.id)
          end
          it 'returns a 302 status code' do
            delete topic_comment_path(@topic.id, @comment.id)
            expect(response).to have_http_status('302')
          end
        end
      end
    end
  end
end
