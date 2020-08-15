require 'rails_helper'

RSpec.describe HashtagHit, type: :model do
  let(:hashtag)   { FactoryBot.create(:hashtag) }
  let(:user)      { FactoryBot.create(:user) }

  describe 'Validations' do
    it 'is valid with a hashtag_id and user_id' do
      hashtag_hit = HashtagHit.new(hashtag: hashtag, user: user)
      expect(hashtag_hit).to be_valid
    end

    it 'is invalid without a hashtag_id' do
      hashtag_hit = HashtagHit.new(hashtag: nil, user: user)
      hashtag_hit.valid?
      expect(hashtag_hit.errors[:hashtag]).to include('を入力してください')
    end

    it 'is invalid without a user_id' do
      hashtag_hit = HashtagHit.new(hashtag: hashtag, user: nil)
      hashtag_hit.valid?
      expect(hashtag_hit.errors[:user]).to include('を入力してください')
    end
  end
end
