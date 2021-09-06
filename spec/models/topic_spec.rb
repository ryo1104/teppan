require 'rails_helper'

RSpec.describe Topic, type: :model do
  let(:user_create)   { create(:user) }
  let(:s3_object) do
    S3_BUCKET.put_object(
      acl: 'public-read-write',
      key: "amazonaws.com/topic_header_images/#{Faker::Lorem.characters(number: 30)}/トラ.jpg",
      body: File.open('spec/fixtures/files/トラ.jpg')
    )
  end

  describe 'Validations' do
    it 'is valid with a user_id, title and text' do
      topic = build(:topic, :with_user)
      expect(topic).to be_valid
    end

    it 'is invalid without a user' do
      topic = build(:topic)
      topic.valid?
      expect(topic.errors[:user]).to include('を入力してください')
    end

    it 'is invalid without a title' do
      topic = build(:topic, :with_user, title: '')
      topic.valid?
      expect(topic.errors[:title]).to include('を入力してください。')
    end

    it 'is invalid with a duplicate title' do
      create(:topic, :with_user, title: 'hogehogehoge title')
      another_topic = build(:topic, :with_user, title: 'hogehogehoge title')
      another_topic.valid?
      expect(another_topic.errors[:title]).to include('はすでに存在します。')
    end

    it 'is invalid if title is longer than 35 characters' do
      topic = build(:topic, :with_user, title: 'あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもや')
      topic.valid?
      expect(topic.errors[:title]).to include('は35文字以内で入力してください。')
    end

    it 'is invalid without a content' do
      topic = build(:topic, :with_user, content: nil)
      topic.valid?
      expect(topic.errors[:content]).to include('を入力してください。')
    end

    it 'is invalid if header_img_url is not AWS S3' do
      topic = build(:topic, :with_user, header_img_url: '/hogehoge_url')
      topic.valid?
      expect(topic.errors[:header_img_url]).to include('が正しくありません。')
    end

    it 'is invalid with invalid header_img_url' do
      topic = build(:topic, :with_user, header_img_url: '//teppan-dev.s3.ap-northeast-1.amazonaws.com/aaaa')
      topic.valid?
      expect(topic.errors[:header_img_url]).to include('が正しくありません。')
    end

    it 'is valid with valid header_img_url ' do
      topic = build(:topic, :with_user, header_img_url: '//teppan-dev.s3.ap-northeast-1.amazonaws.com/topic_header_images/7819d418-1f6a-443a-84ba-fc59a77d5622/mcdonalds.png')
      expect(topic).to be_valid
    end
  end

  describe 'method::max_rate' do
    it 'returns the max rate among the dependent netas average rates' do
      some_topic = create(:topic, user: user_create)
      create(:neta, topic: some_topic, user: user_create, average_rate: 1.25)
      create(:neta, topic: some_topic, user: user_create, average_rate: 2.5)
      create(:neta, topic: some_topic, user: user_create, average_rate: 3)
      create(:neta, topic: some_topic, user: user_create, average_rate: 0)
      create(:neta, topic: some_topic, user: user_create, average_rate: 3.72)
      expect(some_topic.max_rate).to eq 3.72
    end
    it 'returns the max rate among the dependent netas average rates where all rates are same' do
      some_topic = create(:topic, user: user_create)
      create(:neta, topic: some_topic, user: user_create, average_rate: 2.5)
      create(:neta, topic: some_topic, user: user_create, average_rate: 2.5)
      create(:neta, topic: some_topic, user: user_create, average_rate: 2.5)
      expect(some_topic.max_rate).to eq 2.5
    end
    it 'returns 0 when no netas belong to topic' do
      some_topic = create(:topic, user: user_create)
      expect(some_topic.max_rate).to eq 0
    end
  end

  describe 'method::owner(user)' do
    it 'returns true when user is author of topic' do
      some_user = create(:user)
      some_topic = create(:topic, user: some_user)
      expect(some_topic.owner(some_user)).to eq true
    end
    it 'returns false when user is not author of topic' do
      some_user = create(:user)
      another_user = create(:user)
      some_topic = create(:topic, user: another_user)
      expect(some_topic.owner(some_user)).to eq false
    end
  end

  describe 'method::editable(user)' do
    it 'returns true when user is author of topic and only my neta exists' do
      some_user = create(:user)
      some_topic = create(:topic, user: some_user)
      create(:neta, topic: some_topic, user: some_user)
      expect(some_topic.editable(some_user)).to eq true
    end
    it 'returns false when user is author of topic but neta by another user exists' do
      some_user = create(:user)
      another_user = create(:user)
      some_topic = create(:topic, user: some_user)
      create(:neta, topic: some_topic, user: another_user)
      expect(some_topic.editable(some_user)).to eq false
    end
  end

  describe 'method::bookmarked(user_id)' do
    it 'returns false when no bookmark exists on the topic by the user' do
      some_user = create(:user)
      some_topic = create(:topic, user: some_user)
      another_user = create(:user)
      expect(some_topic.bookmarked(another_user.id)).to eq false
    end
    it 'returns true when bookmark already exists on the topic by the user' do
      some_user = create(:user)
      some_topic = create(:topic, user: some_user)
      another_user = create(:user)
      create(:bookmark, bookmarkable: some_topic, user: another_user)
      expect(some_topic.bookmarked(another_user.id)).to eq true
    end
  end

  describe 'method::add_pageview(user)' do
    it 'creates pageview if topic is not viewed by the same user within one day' do
      some_user = create(:user)
      topic = create(:topic, user: some_user)
      another_user = create(:user)
      create(:pageview, pageviewable: topic, user: another_user, created_at: Time.zone.now - 1.day - 1.second)
      expect { topic.add_pageview(another_user) }.to change(Pageview, :count).by(1)
    end
    it 'finds pageview if topic is already viewed by the same user within one day' do
      some_user = create(:user)
      topic = create(:topic, user: some_user)
      another_user = create(:user)
      pageview = create(:pageview, pageviewable: topic, user: another_user, created_at: Time.zone.now - 1.day)
      expect(topic.add_pageview(another_user)).to eq pageview
    end
  end

  describe 'header image direct upload to S3' do
    subject { build(:topic, user: user_create, header_img_url: s3_object.key) }
    it 'saves the url' do
      expect(subject).to be_valid
    end
    it 'saves image to S3' do
      expect(S3_BUCKET.object(subject.header_img_url).presigned_url(:get, expires_in: 300)).not_to be_blank
    end
  end

  describe 'method::deleteable' do
    it 'returns false when associated netas exist' do
      topic = create(:topic, user: user_create)
      create(:neta, topic: topic, user: user_create)
      expect(topic.deleteable).to eq false
    end
    it 'returns true when associated netas does not exist' do
      topic = create(:topic, user: user_create)
      create(:neta, topic: topic, user: user_create)
      expect(topic.deleteable).to eq false
    end
  end

  describe 'method::purge_s3_object' do
    it 'returns true even if header image does not exist' do
      topic = create(:topic, :with_user, header_img_url: nil)
      expect(topic.purge_s3_object).to eq true
    end
    it 'returns false when header_img_url is not valid' do
      topic = create(:topic, :with_user)
      topic.header_img_url = 'http:://'
      expect(topic.purge_s3_object).to eq false
    end
    it 'returns false when header image (S3 obj) does not exist' # do
    #   topic = create(:topic, :with_user, header_img_url: S3_BUCKET.object(s3_object.key).public_url )
    #   allow_any_instance_of(S3_BUCKET).to receive(:object).and_return(nil)
    #   expect(topic.purge_s3_object).to eq false
    # end
    it 'returns true when header image (S3 obj) is deleted' do
      topic = create(:topic, :with_user, header_img_url: S3_BUCKET.object(s3_object.key).public_url)
      expect(topic.purge_s3_object).to eq true
    end
  end
end
