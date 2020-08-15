require 'rails_helper'

RSpec.describe Hashtag, type: :model do
  describe 'Validations' do
    it 'is valid with a hashname, hit_count, and neta_count' do
      hashtag = build(:hashtag)
      expect(hashtag).to be_valid
    end

    it 'is invalid without a hashname' do
      hashtag = build(:hashtag, hashname: '')
      hashtag.valid?
      expect(hashtag.errors[:hashname]).to include('を入力してください。')
    end

    it 'is invalid with a duplicate hashname' do
      create(:hashtag, hashname: 'Myhashtag')
      hashtag = build(:hashtag, hashname: 'Myhashtag')
      hashtag.valid?
      expect(hashtag.errors[:hashname]).to include('はすでに存在します。')
    end

    it 'is invalid if hit_count is blank' do
      follow = build(:hashtag, hit_count: nil)
      follow.valid?
      expect(follow.errors[:hit_count]).to include('を入力してください。')
    end

    it 'is invalid if hit_count is not number' do
      follow = build(:hashtag, hit_count: 'A')
      follow.valid?
      expect(follow.errors[:hit_count]).to include('は数値で入力してください。')
    end

    it 'is invalid if hit_count is not integer' do
      follow = build(:hashtag, hit_count: 1.2)
      follow.valid?
      expect(follow.errors[:hit_count]).to include('は整数で入力してください。')
    end

    it 'is invalid if hit_count is negative' do
      follow = build(:hashtag, hit_count: -1)
      follow.valid?
      expect(follow.errors[:hit_count]).to include('は0以上の値にしてください。')
    end

    it 'is invalid if neta_count is blank' do
      follow = build(:hashtag, neta_count: nil)
      follow.valid?
      expect(follow.errors[:neta_count]).to include('を入力してください。')
    end

    it 'is invalid if neta_count is not number' do
      follow = build(:hashtag, neta_count: 'A')
      follow.valid?
      expect(follow.errors[:neta_count]).to include('は数値で入力してください。')
    end

    it 'is invalid if neta_count is not integer' do
      follow = build(:hashtag, neta_count: 1.2)
      follow.valid?
      expect(follow.errors[:neta_count]).to include('は整数で入力してください。')
    end

    it 'is invalid if neta_count is negative' do
      follow = build(:hashtag, neta_count: -1)
      follow.valid?
      expect(follow.errors[:neta_count]).to include('は0以上の値にしてください。')
    end
  end
end
