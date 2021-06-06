require 'rails_helper'

RSpec.describe LikesController, type: :request do
  let(:user_create)       { create(:user) }
  let(:topic_create)      { create(:topic, :with_user) }
  let(:neta_create)       { create(:neta, :with_user, topic: topic_create) }

  describe 'POST #create' do
    context 'as a signed in user' do
      before do
        @user = user_create
        sign_in @user
        @topic = topic_create
        @comment = Comment.create(commentable: @topic, user: @user, text: Faker::Lorem.characters(number: 100))
      end
      context 'when save succeeds' do
        context 'and Topic is likeable' do
          it 'creates a Like record' do
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
        context 'and Comment is likeable' do
          it 'creates a Like record' do
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
      end
      context 'when save fails' do
        it 'redirects to user page' do
          allow_any_instance_of(Like).to receive(:save).and_return(false)
          post topic_likes_path(@topic.id), xhr: true
          expect(response).to redirect_to user_url(@user.id)
        end
        it 'returns a 302 status code' do
          allow_any_instance_of(Like).to receive(:save).and_return(false)
          post comment_likes_path(@comment.id), xhr: true
          expect(response).to have_http_status('302')
        end
      end
    end
    context 'as a guest' do
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
  end

  describe 'DELETE #destroy' do
    context 'as a signed in user' do
      before do
        @user = user_create
        sign_in @user
        @topic = topic_create
        @comment = Comment.create(commentable: @topic, user: user_create, text: Faker::Lorem.characters(number: 100))
      end
      context 'when destroy succeeds' do
        context 'when Topic is likeable' do
          before do
            @like = Like.create(likeable: @topic, user: @user)
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
              @another_user = create(:user)
              sign_in @another_user
            end
            it 'redirects to topic' do
              delete topic_like_path(@topic.id, @like.id), xhr: true
              expect(response).to redirect_to user_path(@another_user.id)
            end
            it 'returns a 302 status code' do
              delete topic_like_path(@topic.id, @like.id), xhr: true
              expect(response).to have_http_status('302')
            end
          end
        end
        context 'when Comment is likeable' do
          before do
            @like = Like.create(likeable: @comment, user: @user)
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
              @another_user = create(:user)
              sign_in @another_user
            end
            it 'redirects to user' do
              delete comment_like_path(@comment.id, @like.id), xhr: true
              expect(response).to redirect_to user_path(@another_user.id)
            end
            it 'returns a 302 status code' do
              delete comment_like_path(@comment.id, @like.id), xhr: true
              expect(response).to have_http_status('302')
            end
          end
        end
      end
      context 'when destroy fails' do
        before do
          allow_any_instance_of(Like).to receive(:destroy).and_return(false)
          @like = Like.create(likeable: @topic, user: @user)
        end
        it 'redirects to user page' do
          delete topic_like_path(@topic.id, @like.id), xhr: true
          expect(response).to redirect_to user_url(@user.id)
        end
        it 'returns a 302 status code' do
          delete comment_like_path(@comment.id, @like.id), xhr: true
          expect(response).to have_http_status('302')
        end
      end
    end
    context 'as a guest' do
      before do
        @user = user_create
        @topic = topic_create
        @comment = Comment.create(commentable: @topic, user: @user, text: Faker::Lorem.characters(number: 100))
      end
      context 'when Topic is likeable' do
        it 'returns a 401 status code' do
          @like = Like.create(likeable: @topic, user: @user)
          delete topic_like_path(@topic.id, @like.id), xhr: true
          expect(response.status).to eq 401
        end
      end
      context 'when Comment is likeable' do
        it 'returns a 401 status code' do
          @like = Like.create(likeable: @comment, user: @user)
          delete comment_like_path(@comment.id, @like.id), xhr: true
          expect(response.status).to eq 401
        end
      end
    end
  end
end
