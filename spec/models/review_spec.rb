require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:user)  { FactoryBot.create(:user) }
  let(:topic) { FactoryBot.create(:topic, :with_user) }
  let(:neta)  { FactoryBot.create(:neta, :with_user, topic: topic) }

  describe 'Validations' do
    it 'is valid with a user_id, neta_id, and rate' do
      review = build(:review, user: user, neta: neta)
      expect(review).to be_valid
    end

    it 'is invalid without a user' do
      review = build(:review, neta: neta, user: nil)
      review.valid?
      expect(review.errors[:user]).to include('を入力してください')
    end

    it 'is invalid without a neta' do
      review = build(:review, neta: nil, user: user)
      review.valid?
      expect(review.errors[:neta]).to include('を入力してください')
    end

    it 'is invalid without a rate' do
      review = build(:review, neta: neta, user: user, rate: nil)
      review.valid?
      expect(review.errors[:rate]).to include('を入力してください。')
    end

    it 'is invalid if rate is below 1' do
      review = build(:review, neta: neta, user: user, rate: 0)
      review.valid?
      expect(review.errors[:rate]).to include('は1以上の値にしてください。')
    end

    it 'is invalid if rate is greater than 5' do
      review = build(:review, neta: neta, user: user, rate: 6)
      review.valid?
      expect(review.errors[:rate]).to include('は5以下の値にしてください。')
    end

    it 'is invalid if rate is not integer' do
      review = build(:review, neta: neta, user: user, rate: 2.5)
      review.valid?
      expect(review.errors[:rate]).to include('は整数で入力してください。')
    end

    it 'is invalid if text is longer than 200 characters' do
      review = build(:review, neta: neta, user: user, text: Faker::Lorem.characters(number: 201))
      review.valid?
      expect(review.errors[:text]).to include('は200字以内で入力してください。')
    end

    it 'is invalid if duplicate reviews by same user' do
      create(:review, neta: neta, user: user)
      review = build(:review, neta: neta, user: user)
      review.valid?
      expect(review.errors[:user_id]).to include('このネタへのレビューは存在します。')
    end
  end
end
