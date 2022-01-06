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
    before do
      @some_user = create(:user)
      @hashtag = create(:hashtag)
    end
    context 'if no hit exists in the last 24hrs for the hashtag-user pair' do
      before do
        create(:hashtag_hit, hashtag: @hashtag, user: @some_user, created_at: 1.day.ago - 1.second)
        @hashtag.reload
      end
      it 'adds a new record' do
        expect { @hashtag.add_hit(@some_user) }.to change(HashtagHit, :count).by(1)
      end
      it 'increments hit counter' do
        before_count = @hashtag.hit_count
        @hashtag.add_hit(@some_user)
        @hashtag.reload
        after_count = @hashtag.hit_count
        expect(after_count - before_count).to eq 1
      end
    end
    context 'if a hit already exists in the last 24hrs for the hashtag-user pair' do
      before do
        create(:hashtag_hit, hashtag: @hashtag, user: @some_user, created_at: 1.day.ago + 1.second)
        @hashtag.reload
      end
      it 'does not add a new record' do
        expect { @hashtag.add_hit(@some_user) }.to change(HashtagHit, :count).by(0)
      end
      it 'does not increment hit counter' do
        before_count = @hashtag.hit_count
        @hashtag.add_hit(@some_user)
        @hashtag.reload
        after_count = @hashtag.hit_count
        expect(after_count - before_count).to eq 0
      end
    end
  end
end
