require 'rails_helper'

RSpec.describe Follow, type: :model do
  let(:user) { create(:user) }

  describe 'Validations' do
    before do
      @user1 = create(:user)
      @user2 = create(:user)
    end

    it 'is valid with a followed_id and follower_id' do
      follow = build(:follow, followed: @user1, follower: @user2)
      expect(follow).to be_valid
    end

    it 'is invalid without a followed_id' do
      follow = build(:follow, followed_id: nil, follower: @user2)
      follow.valid?
      expect(follow.errors[:followed_id]).to include('は数値で入力してください。')
    end

    it 'is invalid without a follower_id' do
      follow = build(:follow, followed_id: 1, follower_id: nil)
      follow.valid?
      expect(follow.errors[:follower_id]).to include('は数値で入力してください。')
    end

    it 'is invalid if follower_id is not integer' do
      follow = build(:follow, followed: @user1, follower_id: 'A')
      follow.valid?
      expect(follow.errors[:follower_id]).to include('は数値で入力してください。')
    end

    it 'is invalid if followed_id is not integer' do
      follow = build(:follow, followed_id: 'A', follower: @user2)
      follow.valid?
      expect(follow.errors[:followed_id]).to include('は数値で入力してください。')
    end

    it 'is invalid when duplicate pair of followed_id and follower_id exists' do
      create(:follow, followed: @user1, follower: @user2)
      follow = build(:follow, followed: @user1, follower: @user2)
      follow.valid?
      expect(follow.errors[:followed_id]).to include('このフォローはすでに登録されています。')
    end
  end
end
