require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'Validations' do
    before do
      @user = FactoryBot.create(:user)
      @topic = FactoryBot.create(:topic, :with_user)
      @neta = FactoryBot.create(:neta, user: @user, topic: @topic)
    end
    it 'is valid with a user_id, neta_id, and rate' do
      review = build(:review, user: @user, neta: @neta)
      expect(review).to be_valid
    end

    it 'is invalid without a user' do
      review = build(:review, neta: @neta, user: nil)
      review.valid?
      expect(review.errors[:user]).to include('を入力してください')
    end

    it 'is invalid without a neta' do
      review = build(:review, neta: nil, user: @user)
      review.valid?
      expect(review.errors[:neta]).to include('を入力してください')
    end

    it 'is invalid without a rate' do
      review = build(:review, neta: @neta, user: @user, rate: nil)
      review.valid?
      expect(review.errors[:rate]).to include('を入力してください。')
    end

    it 'is invalid if rate is below 1' do
      review = build(:review, neta: @neta, user: @user, rate: 0)
      review.valid?
      expect(review.errors[:rate]).to include('は1以上の値にしてください。')
    end

    it 'is invalid if rate is greater than 5' do
      review = build(:review, neta: @neta, user: @user, rate: 6)
      review.valid?
      expect(review.errors[:rate]).to include('は5以下の値にしてください。')
    end

    it 'is invalid if rate is not integer' do
      review = build(:review, neta: @neta, user: @user, rate: 2.5)
      review.valid?
      expect(review.errors[:rate]).to include('は整数で入力してください。')
    end

    it 'is invalid if text is longer than 200 characters' do
      review = build(:review, neta: @neta, user: @user, text: Faker::Lorem.characters(number: 201))
      review.valid?
      expect(review.errors[:text]).to include('は200字以内で入力してください。')
    end

    it 'is invalid if duplicate reviews by same user' do
      create(:review, neta: @neta, user: @user)
      review = build(:review, neta: @neta, user: @user)
      review.valid?
      expect(review.errors[:user_id]).to include('このネタへのレビューは存在します。')
    end
  end

  describe 'method::details', type: :doing do
    before do
      @user1 = FactoryBot.create(:user)
      @user2 = FactoryBot.create(:user)
      @user3 = FactoryBot.create(:user)
      @topic = FactoryBot.create(:topic, :with_user)
      @neta1 = FactoryBot.create(:neta, user: @user1, topic: @topic)
      @neta2 = FactoryBot.create(:neta, user: @user2, topic: @topic)
      @neta3 = FactoryBot.create(:neta, user: @user3, topic: @topic)
      @review1 = FactoryBot.create(:review, neta: @neta1, user: @user2)
      @review2 = FactoryBot.create(:review, neta: @neta1, user: @user3)
      @review3 = FactoryBot.create(:review, neta: @neta2, user: @user3)
    end
    it 'returns review details when given neta ids' do
      expected_result = {
        "neta_#{@neta1.id}" => {
          "user_#{@user2.id}" => @review1.rate,
          "user_#{@user3.id}" => @review2.rate
        },
        "neta_#{@neta2.id}" => {
          "user_#{@user3.id}" => @review3.rate
        }
      }
      expect(Review.details([@neta1.id, @neta2.id])).to eq expected_result
    end
    it 'returns blank when reviews do not exist for the given neta' do
      expect(Review.details([@neta3.id])).to be_empty
    end
    it 'returns blank when given neta id array is empty' do
      expect(Review.details([])).to be_empty
    end
  end
end
