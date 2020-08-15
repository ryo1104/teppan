require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user)      { FactoryBot.create(:user) }
  let(:topic)     { FactoryBot.create(:topic, :with_user) }
  let(:neta)      { FactoryBot.create(:neta, :with_user, topic: topic) }
  let(:review)    { Review.new(neta: neta, user: user, rate: 5) }
  let(:comment)   { FactoryBot.create(:comment, :with_user, commentable: review) }

  describe 'Validations' do
    it 'is valid with a user_id, topic' do
      like = Like.new(likeable: topic, user: user)
      expect(like).to be_valid
    end

    it 'is valid with a user_id, review' do
      like = Like.new(likeable: review, user: user)
      expect(like).to be_valid
    end

    it 'is valid with a user_id, comment' do
      like = Like.new(likeable: comment, user: user)
      expect(like).to be_valid
    end

    it 'is invalid without a user_id' do
      like = Like.new(likeable: topic, user: nil)
      like.valid?
      expect(like.errors[:user]).to include('を入力してください')
    end

    it 'is invalid without a likeable_id' do
      like = Like.new(likeable_type: 'Topic', likeable_id: nil, user: user)
      like.valid?
      expect(like.errors[:likeable]).to include('を入力してください')
    end

    it 'is invalid without a likeable_type' do
      like = Like.new(likeable_type: nil, likeable_id: 1, user: user)
      like.valid?
      expect(like.errors[:likeable]).to include('を入力してください')
    end

    it 'is invalid if duplicate likes by same user' do
      Like.create(likeable: topic, user: user)
      like = Like.new(likeable: topic, user: user)
      like.valid?
      expect(like.errors[:user_id]).to include('このいいねはすでに存在します。')
    end
  end
end
