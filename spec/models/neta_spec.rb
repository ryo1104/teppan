require 'rails_helper'

RSpec.describe Neta, type: :model do
  let(:user_create)   { FactoryBot.create(:user) }
  let(:topic_create)  { FactoryBot.create(:topic, :with_user) }
  let(:hashtag)       { FactoryBot.create(:hashtag) }

  describe 'Validations' do
    it 'is valid with a user_id, topic_id, text, and price' do
      neta = build(:neta, user: user_create, topic: topic_create)
      expect(neta).to be_valid
    end
    it 'is invalid without a user' do
      neta = build(:neta, user: nil, topic: topic_create)
      neta.valid?
      expect(neta.errors[:user]).to include('を入力してください')
    end
    it 'is invalid without a topic' do
      neta = build(:neta, user: user_create, topic: nil)
      neta.valid?
      expect(neta.errors[:topic]).to include('を入力してください')
    end
    it 'is invalid without a title' do
      neta = build(:neta, user: user_create, topic: topic_create, title: nil)
      neta.valid?
      expect(neta.errors[:title]).to include('を入力してください。')
    end
    it 'is invalid without a content' do
      neta = build(:neta, user: user_create, topic: topic_create, content: nil)
      neta.valid?
      expect(neta.errors[:content]).to include('を入力してください。')
    end
    it 'is invalid if title is longer than 35 characters' do
      neta = build(:neta, user: user_create, topic: topic_create, title: 'あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもや')
      neta.valid?
      expect(neta.errors[:title]).to include('は35字以内で入力してください。')
    end
    it 'is invalid if content is longer than 1200 characters' do
      neta = build(:neta, content: Faker::Lorem.characters(number: 1201), user: user_create, topic: topic_create)
      neta.valid?
      expect(neta.errors[:content]).to include('は1200字以内で入力してください。')
    end
    it 'is invalid if valuecontent exists but price is zero' do
      neta = build(:neta, content: Faker::Lorem.characters(number: 300), price: 0, valuecontent: Faker::Lorem.characters(number: 300), user: user_create, topic: topic_create)
      neta.valid?
      expect(neta.errors[:valuecontent]).to include('は価格０では入力できません。')
    end
    it 'is invalid if valuecontent is longer than 1200 characters' do
      neta = build(:neta, content: Faker::Lorem.characters(number: 1200), price: 100, valuecontent: Faker::Lorem.characters(number: 1201), user: user_create, topic: topic_create)
      neta.valid?
      expect(neta.errors[:valuecontent]).to include('は1200字以内で入力してください。')
    end
    it 'is invalid without a price' do
      neta = build(:neta, user: user_create, topic: topic_create, price: nil)
      neta.valid?
      expect(neta.errors[:price]).to include('を入力してください。')
    end
    it 'is invalid if price is negative' do
      neta = build(:neta, user: user_create, topic: topic_create, price: -1)
      neta.valid?
      expect(neta.errors[:price]).to include('は0以上の値にしてください。')
    end
    it 'is invalid if price is not integer' do
      neta = build(:neta, user: user_create, topic: topic_create, price: 100.1)
      neta.valid?
      expect(neta.errors[:price]).to include('は整数で入力してください。')
    end
    it 'is invalid if price is greater than 10000' do
      neta = build(:neta, user: user_create, topic: topic_create, price: 10_001)
      neta.valid?
      expect(neta.errors[:price]).to include('は10000以下の値にしてください。')
    end
    it 'is invalid if private_flag is blank' do
      neta = build(:neta, user: user_create, topic: topic_create, private_flag: nil)
      neta.valid?
      expect(neta.errors[:private_flag]).to include('が入力にありません。')
    end
    it 'is valid if private_flag is false boolean' do
      neta = build(:neta, user: user_create, topic: topic_create, private_flag: false)
      expect(neta).to be_valid
    end
  end

  describe 'Counters' do
    context 'Topic.netas_count column' do
      before do
        @topic = create(:topic, :with_user)
        @neta = build(:neta, topic: @topic, user: user_create)
      end
      context 'when private_flag is true' do
        before do
          @neta.private_flag = true
        end
        it 'Topic.netas_count column is unchanged' do
          expect { @neta.save! }.to change { @topic.netas_count }.by(0)
        end
        context 'but private_flag is updated to false' do
          it 'Topic.netas_count column increments by 1' do
            @neta.save!
            @topic.reload
            before_count = @topic.netas_count
            @neta.update!(private_flag: false)
            @topic.reload
            after_count = @topic.netas_count
            expect(after_count - before_count).to eq 1
          end
        end
      end
      context 'when private_flag is false' do
        before do
          @neta.private_flag = false
        end
        it 'and Neta is created, Topic.netas_count column increments by 1' do
          @neta.save!
          @topic.reload
          expect(@topic.netas_count).to eq 1
        end
        it 'and Neta is destroyed, Topic.netas_count column decrements by 1' do
          @neta.save!
          @another_neta = create(:neta, topic: @topic, user: user_create, private_flag: false)
          @topic.reload
          before_count = @topic.netas_count
          @neta.destroy!
          @topic.reload
          after_count = @topic.netas_count
          expect(after_count - before_count).to eq(-1)
        end
        context 'but private_flag is updated to true' do
          it 'Topic.netas_count column decrements by 1' do
            @neta.save!
            @topic.reload
            before_count = @topic.netas_count
            @neta.update!(private_flag: true)
            @topic.reload
            after_count = @topic.netas_count
            expect(after_count - before_count).to eq(-1)
          end
        end
      end
    end
  end

  describe 'method::average_rate(netas)' do
    it 'returns average review rate from multiple netas' do
      user = user_create
      topic1 = create(:topic, :with_user)
      topic2 = create(:topic, :with_user)
      topic3 = create(:topic, :with_user)
      create(:neta, user: user, topic: topic1, reviews_count: 4, average_rate: 3.11)
      create(:neta, user: user, topic: topic2, reviews_count: 3, average_rate: 3.72)
      create(:neta, user: user, topic: topic3, reviews_count: 1, average_rate: 0)
      expect(Neta.average_rate(user.netas)).to eq (((3.11 * 4) + (3.72 * 3) + (0 * 1)) / (4 + 3 + 1)).round(2)
    end
    it 'returns 0 when no netas by user' do
      user = user_create
      expect(Neta.average_rate(user.netas)).to eq 0
    end
    it 'returns 0 when netas exist but with no reviews' do
      user = user_create
      topic = create(:topic, :with_user)
      create(:neta, user: user, topic: topic)
      expect(Neta.average_rate(user.netas)).to eq 0
    end
  end

  describe 'method::update_average_rate' do
    it 'updates attribute average_rate with reviews' do
      neta = create(:neta, user: user_create, topic: topic_create)
      create(:review, :with_user, neta: neta, rate: 3)
      create(:review, :with_user, neta: neta, rate: 4)
      create(:review, :with_user, neta: neta, rate: 5)
      create(:review, :with_user, neta: neta, rate: 5)
      neta.update_average_rate
      expect(neta.average_rate).to eq 4.25
    end
    it "returns false when reviews don't exist" do
      neta = create(:neta, user: user_create, topic: topic_create)
      expect(neta.update_average_rate).to eq [false, 'no reviews exist for the neta']
    end
    it 'does not update attribute average_rate when no reviews exist' do
      neta = create(:neta, user: user_create, topic: topic_create)
      neta.update_average_rate
      expect(neta.average_rate).to eq 0
    end
    it 'returns false when update fails' do
      neta = create(:neta, user: user_create, topic: topic_create)
      create(:review, :with_user, neta: neta, rate: 3)
      create(:review, :with_user, neta: neta, rate: 4)
      allow_any_instance_of(Neta).to receive(:update).and_return(false)
      expect(neta.update_average_rate).to eq [false, 'error updating average_rate']
    end
  end

  describe 'method::owner' do
    it 'returns true if user is neta owner' do
      some_user = user_create
      neta = create(:neta, user: some_user, topic: topic_create)
      expect(neta.owner(some_user)).to eq true
    end

    it 'returns false if user is not neta owner' do
      some_user = create(:user)
      another_user = create(:user)
      neta = create(:neta, user: some_user, topic: topic_create)
      expect(neta.owner(another_user)).to eq false
    end
  end

  describe 'method::editable' do
    it 'returns true if no trade exists on the neta' do
      neta = create(:neta, user: user_create, topic: topic_create)
      expect(neta.editable).to eq true
    end

    it 'returns false if trade exists on the neta' do
      neta = create(:neta, user: user_create, topic: topic_create)
      create(:trade, tradeable: neta)
      expect(neta.editable).to eq false
    end
  end

  describe 'method::for_sale' do
    before do
      @user = user_create
      @neta = create(:neta, :with_valuecontent, user: @user, topic: topic_create, price: 100)
    end
    it 'returns false if price is zero' do
      @neta.price = 0
      expect(@neta.for_sale).to eq false
    end
    it 'returns false if user is not premium user' do
      allow(@user).to receive(:premium_user).and_return([false, nil, nil])
      account = instance_double('StripeAccount', status: 'verified')
      allow(@user).to receive(:stripe_account).and_return(account)
      expect(@neta.for_sale).to eq false
    end
    it 'returns false if user is premium user but account does not exist' do
      allow(@user).to receive(:premium_user).and_return([true, nil, nil])
      expect(@neta.for_sale).to eq false
    end
    it 'returns false if user is premium user and account exists, but account status is not verified' do
      account = instance_double('StripeAccount', status: 'unverified')
      allow(@user).to receive(:premium_user).and_return([true, nil, nil])
      allow(@user).to receive(:stripe_account).and_return(account)
      expect(@neta.for_sale).to eq false
    end
    it 'returns true if user is premium user and account status is verified' do
      account = instance_double('StripeAccount', status: 'verified')
      allow(@user).to receive(:premium_user).and_return([true, nil, nil])
      allow(@user).to receive(:stripe_account).and_return(account)
      expect(@neta.for_sale).to eq true
    end
  end

  describe 'method::public_str' do
    it 'returns 非公開 when private_flag is true' do
      neta = create(:neta, user: user_create, topic: topic_create, private_flag: true)
      expect(neta.public_str).to eq '非公開'
    end
    it 'returns 公開 when private_flag is false' do
      neta = create(:neta, user: user_create, topic: topic_create, private_flag: false)
      expect(neta.public_str).to eq '公開'
    end
  end

  describe 'method::add_pageview' do
    it 'creates pageview if neta is not viewed by the same user within one day' do
      some_user = create(:user)
      neta = create(:neta, user: some_user, topic: topic_create)
      another_user = create(:user)
      create(:pageview, pageviewable: neta, user: another_user, created_at: Time.zone.now - 1.day - 1.second)
      expect { neta.add_pageview(another_user) }.to change(Pageview, :count).by(1)
    end
    it 'finds pageview if neta is already viewed by the same user within one day' do
      some_user = create(:user)
      neta = create(:neta, user: some_user, topic: topic_create)
      another_user = create(:user)
      pageview = create(:pageview, pageviewable: neta, user: another_user, created_at: Time.zone.now - 1.day)
      expect(neta.add_pageview(another_user)).to eq pageview
    end
  end

  describe 'method::dependents' do
    it 'returns true if review exists' do
      neta = create(:neta, user: user_create, topic: topic_create)
      create(:review, :with_user, neta: neta)
      expect(neta.dependents).to eq true
    end
    it 'returns true if trade exists' do
      neta = create(:neta, user: user_create, topic: topic_create)
      create(:trade, tradeable: neta)
      expect(neta.dependents).to eq true
    end
    it 'returns true if bookmark exists' do
      neta = create(:neta, user: user_create, topic: topic_create)
      create(:bookmark, bookmarkable: neta, user: user_create)
      expect(neta.dependents).to eq true
    end
    it 'returns true if exists in ranking' do
      neta = create(:neta, user: user_create, topic: topic_create)
      create(:ranking, rankable: neta, rank: 1, score: 10)
      expect(neta.dependents).to eq true
    end
    it 'returns false if no dependent data exists' do
      neta = create(:neta, user: user_create, topic: topic_create)
      expect(neta.dependents).to eq false
    end
  end

  describe 'method::bookmarked' do
    it 'returns true if bookmarked by the given user' do
      neta = create(:neta, user: user_create, topic: topic_create)
      some_user = user_create
      create(:bookmark, bookmarkable: neta, user: some_user)
      expect(neta.bookmarked(some_user.id)).to eq true
    end
    it 'returns false if not bookmarked by the given user' do
      neta = create(:neta, user: user_create, topic: topic_create)
      some_user1 = create(:user)
      some_user2 = create(:user)
      create(:bookmark, bookmarkable: neta, user: some_user1)
      expect(neta.bookmarked(some_user2.id)).to eq false
    end
  end

  describe 'method::save_with_hashtags' do
    subject { @neta.save_with_hashtags(@tags) }
    before do
      @neta = build(:neta, user: user_create, topic: topic_create)
      @tags = %w[tag1 tag2 tag3]
      @hashtag1 = create(:hashtag, hashname: 'tag1')
      @hashtag2 = create(:hashtag, hashname: 'tag2')
      @other_neta = create(:neta, user: user_create, topic: topic_create)
      create(:hashtag_neta, neta: @other_neta, hashtag: @hashtag2)
    end
    context 'when tag array exists' do
      it 'creates Hashtag if it does not exist' do
        expect { subject }.to change(Hashtag, :count).by(1)
      end
      it 'creates HashtagNeta relationship' do
        expect { subject }.to change(HashtagNeta, :count).by(3)
      end
      it 'returns true if hashtags have been successfully added' do
        expect(subject).to eq true
      end
      it 'saves Neta successfully' do
        expect { subject }.to change(Neta, :count).by(1)
      end
      it 'returns error if hashtags exceeds 10 words' do
        @tags = %w[タグ1 tag2 tag3 tag4 tag5 タグ6 tag7 tag8 tag9 tag10 tag11]
        subject
        expect(@neta.errors[:hashtags]).to include('は10個までです。')
      end
      it 'returns false if hashtags exceeds 10 words' do
        @tags = %w[タグ1 tag2 tag3 tag4 tag5 タグ6 tag7 tag8 tag9 tag10 tag11]
        expect(subject).to eq false
      end
    end
    context 'when tag array is empty' do
      before do
        @tags = []
      end
      it 'returns true' do
        expect(subject).to eq true
      end
      it 'saves Neta' do
        expect { subject }.to change(Neta, :count).by(1)
      end
    end
    context 'when ActiveRecord exception occurs' do
      before do
        allow(Hashtag).to receive(:find_or_create_by).and_raise(ActiveRecord::RecordInvalid)
      end
      it 'rolls back transaction' do
        expect { subject }.to change(Neta, :count).by(0)
      end
      it 'returns false' do
        expect(subject).to eq false
      end
    end
  end

  describe 'method::delete_with_hashtags' do
    subject { @neta.delete_with_hashtags }
    before do
      @neta = create(:neta, user: user_create, topic: topic_create)
      @hashtag1 = create(:hashtag, hashname: 'tag1')
      @hashtag2 = create(:hashtag, hashname: 'tag2')
      @hashtag3 = create(:hashtag, hashname: 'tag3')

      @other_neta = create(:neta, user: user_create, topic: topic_create)
      create(:hashtag_neta, neta: @other_neta, hashtag: @hashtag2)
    end
    context 'when associated hashtags exist' do
      before do
        create(:hashtag_neta, neta: @neta, hashtag: @hashtag1)
        create(:hashtag_neta, neta: @neta, hashtag: @hashtag3)
      end
      it 'deletes Neta' do
        expect { subject }.to change(Neta, :count).by(-1)
      end
      it 'returns true' do
        expect(subject).to eq true
      end
      it 'deletes associated rows in HashtagNeta' do
        expect { subject }.to change(HashtagNeta, :count).by(-2)
      end
      it 'does not delete the Hashtag itself' do
        expect { subject }.to change(Hashtag, :count).by(0)
      end
    end
    context 'when associated hashtags do not exist' do
      it 'deletes Neta' do
        expect { subject }.to change(Neta, :count).by(-1)
      end
      it 'returns true' do
        expect(subject).to eq true
      end
      it 'does not change HashtagNeta total count' do
        expect { subject }.to change(HashtagNeta, :count).by(0)
      end
      it 'does not delete the Hashtag itself' do
        expect { subject }.to change(Hashtag, :count).by(0)
      end
    end
    context 'when ActiveRecord exception occurs' do
      before do
        allow_any_instance_of(Neta).to receive(:destroy!).and_raise(ActiveRecord::RecordInvalid)
        create(:hashtag_neta, neta: @neta, hashtag: @hashtag1)
        create(:hashtag_neta, neta: @neta, hashtag: @hashtag3)
      end
      it 'rolls back transaction' do
        expect { subject }.to change(HashtagNeta, :count).by(0)
      end
      it 'returns false' do
        expect(subject).to eq false
      end
    end
  end

  describe 'clear_hashtags' do
    subject { @neta.clear_hashtags }
    before do
      @neta = create(:neta, user: user_create, topic: topic_create)
      @other_neta = create(:neta, user: user_create, topic: topic_create)
      hashtag1 = create(:hashtag, hashname: 'tag1')
      create(:hashtag_neta, neta: @neta, hashtag: hashtag1)
      hashtag2 = create(:hashtag, hashname: 'tag2')
      create(:hashtag_neta, neta: @neta, hashtag: hashtag2)
      hashtag3 = create(:hashtag, hashname: 'tag3')
      create(:hashtag_neta, neta: @neta, hashtag: hashtag3)
      create(:hashtag_neta, neta: @other_neta, hashtag: hashtag3)
    end
    it 'deletes all neta-hashtag pair for this neta' do
      subject
      expect(HashtagNeta.where(neta_id: @neta.id).count).to eq 0
    end
    it 'does not delete neta-hashtag pair for other neta' do
      subject
      expect(HashtagNeta.where(neta_id: @other_neta.id).count).to eq 1
    end
    it 'does not delete hashtag itself' do
      subject
      expect(Hashtag.all.count).to eq 3
    end
  end

  describe 'method::hashtags_str' do
    before do
      @neta = create(:neta, user: user_create, topic: topic_create)
      @other_neta = create(:neta, user: user_create, topic: topic_create)
    end
    it 'returns string of hashtags split by commas' do
      hashtag1 = create(:hashtag, hashname: 'tag1')
      create(:hashtag_neta, neta: @neta, hashtag: hashtag1)
      hashtag2 = create(:hashtag, hashname: 'tag2')
      create(:hashtag_neta, neta: @neta, hashtag: hashtag2)
      hashtag3 = create(:hashtag, hashname: 'tag3')
      create(:hashtag_neta, neta: @other_neta, hashtag: hashtag3)
      expect(@neta.hashtags_str).to eq 'tag1,tag2'
    end
    it 'returns blank string if no hashtags associated exist' do
      expect(@neta.hashtags_str).to eq ''
    end
  end
end
