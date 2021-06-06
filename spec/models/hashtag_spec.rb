require 'rails_helper'

RSpec.describe Hashtag, type: :model do
  describe 'Validations' do
    it 'is valid with a hashname, hit_count, and neta_count' do
      hashtag = build(:hashtag)
      expect(hashtag).to be_valid
    end

    context 'hashname' do
      it 'is valid with numbers' do
        hashtag = build(:hashtag, hashname: '12345')
        expect(hashtag).to be_valid
      end

      it 'is valid with alphanumeric' do
        hashtag = build(:hashtag, hashname: 'tag1')
        expect(hashtag).to be_valid
      end

      it 'is valid with hiragana katakana' do
        hashtag = build(:hashtag, hashname: 'ひらがなカタカナー')
        expect(hashtag).to be_valid
      end

      it 'is valid with kanji' do
        hashtag = build(:hashtag, hashname: '漢字')
        expect(hashtag).to be_valid
      end

      it 'is valid with everything mixed' do
        hashtag = build(:hashtag, hashname: '漢字ひらがなカタカナ012０１２abcABC')
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
    end

    # context 'yomigana' do
    #   it 'is valid if hiragana katakana' do
    #     hashtag = build(:hashtag, yomigana: 'ひらがなカタカナー')
    #     expect(hashtag).to be_valid
    #   end
    # it 'is valid if hiragana katakana alphanumeric' do
    #     hashtag = build(:hashtag, yomigana: 'ひらがなカタカナーAbc123')
    #     expect(hashtag).to be_valid
    #   end
    #   it 'is invalid if kanji' do
    #     hashtag = build(:hashtag, hashname: '試験用ハッシュタグ1A', yomigana: '試験用ハッシュタグ1A')
    #     hashtag.valid?
    #     expect(hashtag.errors[:yomigana]).to include('はひらがな・英数字が入力可能です。（句読点や記号は不可）')
    #   end
    #   it 'is invalid if special characters' do
    #     hashtag = build(:hashtag, hashname: '試験用ハッシュタグ', yomigana: 'しけんよう・ハッシュタグ')
    #     hashtag.valid?
    #     expect(hashtag.errors[:yomigana]).to include('はひらがな・英数字が入力可能です。（句読点や記号は不可）')
    #   end
    # end

    context 'hit_count' do
      it 'is invalid if blank' do
        follow = build(:hashtag, hit_count: nil)
        follow.valid?
        expect(follow.errors[:hit_count]).to include('を入力してください。')
      end

      it 'is invalid if not number' do
        follow = build(:hashtag, hit_count: 'A')
        follow.valid?
        expect(follow.errors[:hit_count]).to include('は数値で入力してください。')
      end

      it 'is invalid if not integer' do
        follow = build(:hashtag, hit_count: 1.2)
        follow.valid?
        expect(follow.errors[:hit_count]).to include('は整数で入力してください。')
      end

      it 'is invalid if negative' do
        follow = build(:hashtag, hit_count: -1)
        follow.valid?
        expect(follow.errors[:hit_count]).to include('は0以上の値にしてください。')
      end
    end

    context 'neta_count' do
      it 'is invalid if blank' do
        follow = build(:hashtag, neta_count: nil)
        follow.valid?
        expect(follow.errors[:neta_count]).to include('を入力してください。')
      end

      it 'is invalid if not number' do
        follow = build(:hashtag, neta_count: 'A')
        follow.valid?
        expect(follow.errors[:neta_count]).to include('は数値で入力してください。')
      end

      it 'is invalid if not integer' do
        follow = build(:hashtag, neta_count: 1.2)
        follow.valid?
        expect(follow.errors[:neta_count]).to include('は整数で入力してください。')
      end

      it 'is invalid if negative' do
        follow = build(:hashtag, neta_count: -1)
        follow.valid?
        expect(follow.errors[:neta_count]).to include('は0以上の値にしてください。')
      end
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

  # describe 'method::update_yomigana' do
  #   context 'with valid data', type: :doing do
  #     it 'updates hashtag with hiragana' do
  #       hashtag = create(:hashtag, hashname: '試験用ハッシュタグ1A２')
  #       hashtag.update_yomigana
  #       expect(hashtag.yomigana).to eq 'しけんようはっしゅたぐ1A２'
  #     end
  #     it 'returns true' do
  #       hashtag = create(:hashtag, hashname: '試験用ハッシュタグ1A２')
  #       expect(hashtag.update_yomigana).to eq true
  #     end
  #   end
  #   context 'with invalid data' do
  #     before do
  #       rubifuri_mock = double('Rubifuri client')
  #       allow(Rubyfuri::Client).to receive(:new).and_return(rubifuri_mock)
  #       allow(rubifuri_mock).to receive(:furu).and_return('しけんようハッシュ・タグ')
  #     end
  #     it 'logs warning if rubifuri returned a invalid yomigana' do
  #       hashtag = build(:hashtag, hashname: '試験用ハッシュタグ')
  #       expect(Rails.logger).to receive(:warn).with('Error updating yomigana for Hashtag 試験用ハッシュタグ, result was : しけんようハッシュ・タグ')
  #       hashtag.update_yomigana
  #     end
  #     it 'returns false' do
  #       allow_any_instance_of(Hashtag).to receive(:save).and_return(false)
  #       hashtag = build(:hashtag, hashname: '試験用ハッシュタグ')
  #       expect(hashtag.update_yomigana).to eq false
  #     end
  #   end
  # end
end
