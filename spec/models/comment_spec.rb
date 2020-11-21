require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user)      { FactoryBot.create(:user) }
  let(:topic)     { FactoryBot.create(:topic, :with_user) }

  describe 'Validations' do
    it 'is valid with a user_id, topic' do
      comment = Comment.new(commentable: topic, user: user, text: Faker::Lorem.characters(number: 2))
      expect(comment).to be_valid
    end

    it 'is invalid without a user_id' do
      comment = Comment.new(commentable: topic, user: nil)
      comment.valid?
      expect(comment.errors[:user]).to include('を入力してください')
    end

    it 'is invalid without a commentable_id' do
      comment = Comment.new(commentable_type: 'Topic', commentable_id: nil, user: user)
      comment.valid?
      expect(comment.errors[:commentable]).to include('を入力してください')
    end

    it 'is invalid without a commentable_type' do
      comment = Comment.new(commentable_type: nil, commentable_id: 1, user: user)
      comment.valid?
      expect(comment.errors[:commentable]).to include('を入力してください')
    end

    it 'is invalid if text is longer than 200 characters' do
      comment = Comment.new(commentable: topic, user: user, text: Faker::Lorem.characters(number: 201))
      comment.valid?
      expect(comment.errors[:text]).to include('は200文字以内で入力してください。')
    end

    it 'is invalid if likes count is not a number' do
      comment = Comment.create(commentable: topic, user: user, text: Faker::Lorem.characters(number: 100))
      comment.update(likes_count: 'a')
      comment.valid?
      expect(comment.errors[:likes_count]).to include('は数値で入力してください。')
    end

    it 'is invalid if likes count is not a integer' do
      comment = Comment.create(commentable: topic, user: user, text: Faker::Lorem.characters(number: 100))
      comment.update(likes_count: 1.5)
      comment.valid?
      expect(comment.errors[:likes_count]).to include('は整数で入力してください。')
    end

    it 'is invalid if likes count is negative' do
      comment = Comment.create(commentable: topic, user: user, text: Faker::Lorem.characters(number: 100))
      comment.update(likes_count: -1)
      comment.valid?
      expect(comment.errors[:likes_count]).to include('は0以上の値にしてください。')
    end

    it 'is invalid if is_deleted flag is nil' do
      comment = Comment.new(commentable: topic, user: user, text: Faker::Lorem.characters(number: 200), is_deleted: nil)
      comment.valid?
      expect(comment.errors[:is_deleted]).to include('が入力にありません。')
    end
  end
end
