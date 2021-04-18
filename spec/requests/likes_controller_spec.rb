require 'rails_helper'

RSpec.describe LikesController, type: :request do
  let(:user_create)       { FactoryBot.create(:user) }
  let(:topic_create)      { FactoryBot.create(:topic, :with_user) }
  let(:neta_create)       { FactoryBot.create(:neta, :with_user, topic: topic_create) }

  describe 'POST #create' do
    context 'as a signed in user' do
      before do
        @user = user_create
        sign_in @user
      end
      context 'when Topic is likeable' do
        before do
          @topic = topic_create
        end
        it 'populates @likeable' do
          post topic_likes_path(@topic.id), xhr: true
          expect(assigns(:likeable)).to eq @topic
        end
        it 'creates a like' do
          expect do
            post topic_likes_path(@topic.id), xhr: true
          end.to change(Like, :count).by(1)
        end
        it 'user_id of new record is current user' do
          post topic_likes_path(@topic.id), xhr: true
          new_like = Like.last
          expect(new_like.user_id).to eq @user.id
        end
        it 'likeable type of new record is Topic' do
          post topic_likes_path(@topic.id), xhr: true
          new_like = Like.last
          expect(new_like.likeable_type).to eq 'Topic'
        end
        it 'likeable id of new record is topic id' do
          post topic_likes_path(@topic.id), xhr: true
          new_like = Like.last
          expect(new_like.likeable_id).to eq @topic.id
        end
        it 'returns a 200 status code' do
          post topic_likes_path(@topic.id), xhr: true
          expect(response).to have_http_status('200')
        end
      end
      context 'when Comment is likeable' do
        before do
          @topic = topic_create
          @comment = Comment.create(commentable: @topic, user: @user, text: Faker::Lorem.characters(number: 100))
        end
        it 'populates @likeable' do
          post comment_likes_path(@comment.id), xhr: true
          expect(assigns(:likeable)).to eq @comment
        end
        it 'adds record to Like table' do
          expect do
            post comment_likes_path(@comment.id), xhr: true
          end.to change(Like, :count).by(1)
        end
        it 'user_id of new record is current user' do
          post comment_likes_path(@comment.id), xhr: true
          new_like = Like.last
          expect(new_like.user_id).to eq @user.id
        end
        it 'likeable type of new record is Comment' do
          post comment_likes_path(@comment.id), xhr: true
          new_like = Like.last
          expect(new_like.likeable_type).to eq 'Comment'
        end
        it 'likeable id of new record is comment id' do
          post comment_likes_path(@comment.id), xhr: true
          new_like = Like.last
          expect(new_like.likeable_id).to eq @comment.id
        end
        it 'returns a 200 status code' do
          post comment_likes_path(@comment.id), xhr: true
          expect(response).to have_http_status('200')
        end
      end
      context 'when Review is likeable' do
        before do
          @neta = neta_create
          @review = Review.create(neta: @neta, user: user_create, text: Faker::Lorem.characters(number: 100), rate: 1)
        end
        it 'populates @likeable' do
          post review_likes_path(@review.id), xhr: true
          expect(assigns(:likeable)).to eq @review
        end
        it 'adds record to Like table' do
          expect do
            post review_likes_path(@review.id), xhr: true
          end.to change(Like, :count).by(1)
        end
        it 'user_id of new record is current user' do
          post review_likes_path(@review.id), xhr: true
          new_like = Like.last
          expect(new_like.user_id).to eq @user.id
        end
        it 'likeable type of new record is Review' do
          post review_likes_path(@review.id), xhr: true
          new_like = Like.last
          expect(new_like.likeable_type).to eq 'Review'
        end
        it 'likeable id of new record is review id' do
          post review_likes_path(@review.id), xhr: true
          new_like = Like.last
          expect(new_like.likeable_id).to eq @review.id
        end
        it 'returns a 200 status code' do
          post review_likes_path(@review.id), xhr: true
          expect(response).to have_http_status('200')
        end
      end
    end

    context 'as a guest' do
      context 'when Topic is likeable' do
        before do
          @topic = topic_create
        end
        it 'redirects to user sign-in page'
        it 'returns a 401 status code' do
          post topic_likes_path(@topic.id), xhr: true
          expect(response).to have_http_status('401')
        end
      end
      context 'when Comment is likeable' do
        before do
          @user = user_create
          @topic = topic_create
          @comment = Comment.create(commentable: @topic, user: @user, text: Faker::Lorem.characters(number: 100))
        end
        it 'returns a 401 status code' do
          post comment_likes_path(@comment.id), xhr: true
          expect(response.status).to eq 401
        end
      end
      context 'when Review is likeable' do
        before do
          @user = user_create
          @neta = neta_create
          @review = Review.create(neta: @neta, user: @user, text: Faker::Lorem.characters(number: 100), rate: 1)
        end
        it 'returns a 401 status code' do
          post review_likes_path(@review.id), xhr: true
          expect(response).to have_http_status('401')
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
      context 'when Topic is likeable' do
        before do
          @topic = topic_create
          @like = Like.create(likeable: @topic, user: @user)
        end
        it 'populates @likeable' do
          delete topic_like_path(@topic.id, @like.id), xhr: true
          expect(assigns(:likeable)).to eq @topic
        end
        it 'deletes record from Like table' do
          expect do
            delete topic_like_path(@topic.id, @like.id), xhr: true
          end.to change(Like, :count).by(-1)
        end
        it 'returns a 200 status code' do
          delete topic_like_path(@topic.id, @like.id), xhr: true
          expect(response).to have_http_status('200')
        end
        context 'when current user is not owner of like' do
          before do
            sign_out @user
            @another_user = FactoryBot.create(:user)
            sign_in @another_user
          end
          it 'redirects to topic' do
            delete topic_like_path(@topic.id, @like.id), xhr: true
            expect(response).to redirect_to "/topics/#{@topic.id}"
          end
          it 'returns a 302 status code' do
            delete topic_like_path(@topic.id, @like.id), xhr: true
            expect(response).to have_http_status('302')
          end
        end
      end
      context 'when Comment is likeable' do
        before do
          @topic = topic_create
          @comment = Comment.create(commentable: @topic, user: user_create, text: Faker::Lorem.characters(number: 100))
          @like = Like.create(likeable: @comment, user: @user)
        end
        it 'populates @likeable' do
          delete comment_like_path(@comment.id, @like.id), xhr: true
          expect(assigns(:likeable)).to eq @comment
        end
        it 'deletes record from Like table' do
          expect do
            delete comment_like_path(@comment.id, @like.id), xhr: true
          end.to change(Like, :count).by(-1)
        end
        it 'returns a 200 status code' do
          delete comment_like_path(@comment.id, @like.id), xhr: true
          expect(response).to have_http_status('200')
        end
        context 'when current user is not owner of like' do
          before do
            sign_out @user
            @another_user = FactoryBot.create(:user)
            sign_in @another_user
          end
          it 'redirects to comment' do
            delete comment_like_path(@comment.id, @like.id), xhr: true
            expect(response).to redirect_to "/comments/#{@comment.id}"
          end
          it 'returns a 302 status code' do
            delete comment_like_path(@comment.id, @like.id), xhr: true
            expect(response).to have_http_status('302')
          end
        end
      end
      context 'when Review is likeable' do
        before do
          @neta = neta_create
          @review = Review.create(neta: @neta, user: user_create, text: Faker::Lorem.characters(number: 100), rate: 1)
          @like = Like.create(likeable: @review, user: @user)
        end
        it 'populates @likeable' do
          delete review_like_path(@review.id, @like.id), xhr: true
          expect(assigns(:likeable)).to eq @review
        end
        it 'deletes record from Like table' do
          expect do
            delete review_like_path(@review.id, @like.id), xhr: true
          end.to change(Like, :count).by(-1)
        end
        it 'returns a 200 status code' do
          delete review_like_path(@review.id, @like.id), xhr: true
          expect(response).to have_http_status('200')
        end
        context 'when current user is not owner of like' do
          before do
            sign_out @user
            @another_user = FactoryBot.create(:user)
            sign_in @another_user
          end
          it 'redirects to review' do
            delete review_like_path(@review.id, @like.id), xhr: true
            expect(response).to redirect_to "/reviews/#{@review.id}"
          end
          it 'returns a 302 status code' do
            delete review_like_path(@review.id, @like.id), xhr: true
            expect(response).to have_http_status('302')
          end
        end
      end
    end
  end
end
