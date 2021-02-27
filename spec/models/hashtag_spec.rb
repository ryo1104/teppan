require 'rails_helper'

RSpec.describe Hashtag, type: :model do
  describe 'Validations' do
    it 'is valid with a hashname, hit_count, and neta_count' do
      hashtag = build(:hashtag)
      expect(hashtag).to be_valid
    end

    it 'is valid with numbers' do
      hashtag = build(:hashtag, hashname: '12345')
      expect(hashtag).to be_valid
    end

    it 'is valid with hiragana katakana' do
      hashtag = build(:hashtag, hashname: 'ひらがなカタカナ')
      expect(hashtag).to be_valid
    end

    it 'is invalid with special characters' do
      hashtag = build(:hashtag, hashname: '#test')
      hashtag.valid?
      expect(hashtag.errors[:hashname]).to include('は英数字・全角かなのみ入力可能です。')
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

  describe 'method::add_hit' do
    it 'adds a new record for the user if no hit exists in the last 1 day' do
      some_user = create(:user)
      hashtag = create(:hashtag)
      create(:hashtag_hit, hashtag: hashtag, user: some_user, created_at: Time.zone.now - 1.day - 1.second)
      expect { hashtag.add_hit(some_user) }.to change(HashtagHit, :count).by(1)
    end
    it 'increments hit count if no hit exists in the last 1 day' do
      some_user = create(:user)
      hashtag = create(:hashtag)
      create(:hashtag_hit, hashtag: hashtag, user: some_user, created_at: Time.zone.now - 1.day - 1.second)
      expect { hashtag.add_hit(some_user) }.to change(hashtag, :hit_count).by(1)
    end
    it 'does not add a new record for the user if already exists in the last 1 day' do
      some_user = create(:user)
      hashtag = create(:hashtag)
      create(:hashtag_hit, hashtag: hashtag, user: some_user, created_at: Time.zone.now - 1.day + 1.second)
      expect { hashtag.add_hit(some_user) }.to change(HashtagHit, :count).by(0)
    end
    it 'does not add a new record for the user if already exists in the last 1 day' do
      some_user = create(:user)
      hashtag = create(:hashtag)
      create(:hashtag_hit, hashtag: hashtag, user: some_user, created_at: Time.zone.now - 1.day + 1.second)
      expect { hashtag.add_hit(some_user) }.to change(hashtag, :hit_count).by(0)
    end
  end

  describe 'method::update_netacount' do
    it 'updates neta count field' do
      some_user = create(:user)
      some_topic = create(:topic, user: some_user)
      some_hashtag = create(:hashtag)
      some_neta = create(:neta, user: some_user, topic: some_topic)
      create(:hashtag_neta, neta_id: some_neta.id, hashtag_id: some_hashtag.id)
      hashtag = Hashtag.first
      hashtag.update_netacount
      expect(hashtag.neta_count).to eq 1
    end
  end

  describe 'method::update_hiragana' do
    it 'updates hashtag with hiragana' do
      hashtag = build(:hashtag, hashname: nil)
      hashtag.update_hiragana
      expect(hashtag.hiragana).to eq 'てすと'
    end

    it 'returns false if rubifuri returned a non-hiragana', type: :doing do
      rubifuri_mock = double('Rubifuri client')
      allow(Rubyfuri::Client).to receive(:new).and_return(rubifuri_mock)
      allow(rubifuri_mock).to receive(:furu).and_return('カタカナテスト')
      hashtag = build(:hashtag)
      expect(hashtag.update_hiragana).to eq false
    end

    it 'logs warning if rubifuri returned a non-hiragana', type: :doing do
      rubifuri_mock = double('Rubifuri client')
      allow(Rubyfuri::Client).to receive(:new).and_return(rubifuri_mock)
      allow(rubifuri_mock).to receive(:furu).and_return('カタカナテスト')
      hashtag = build(:hashtag)
      expect(Rails.logger).to receive(:warn).with('Rubyfuri returned a non hiragana : カタカナテスト')
      hashtag.update_hiragana
    end
  end
end
