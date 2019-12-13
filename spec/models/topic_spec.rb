require 'rails_helper'

RSpec.describe Topic, type: :model do
  let(:user_create)   { FactoryBot.create(:user) }
  
  describe "Validations", type: :doing do
  
    it "is valid with a user_id, title and text" do
      topic = build(:topic, :with_user)
      expect(topic).to be_valid
    end
    
    it "is invalid without a user" do
      topic = build(:topic)
      topic.valid?
      expect(topic.errors[:user]).to include("を入力してください")
    end
    
    it "is invalid without a title" do
      topic = build(:topic, :with_user, title: "")
      topic.valid?
      expect(topic.errors[:title]).to include("を入力してください。")
    end
    
    it "is invalid with a duplicate title" do
      create(:topic, :with_user, title: "hogehogehoge title")
      another_topic = build(:topic, :with_user, title: "hogehogehoge title")
      another_topic.valid?
      expect(another_topic.errors[:title]).to include("はすでに存在します。")
    end
    
    it "is invalid if title is longer than 30 characters" do
      topic = build(:topic, :with_user, title: Faker::Lorem.characters(number: 31) )
      topic.valid?
      expect(topic.errors[:title]).to include("は30文字以内で入力してください。")
    end
    
    it "is invalid without a content" do
      topic = build(:topic, :with_user, content: nil)
      topic.valid?
      expect(topic.errors[:content]).to include(" cannot be blank")
    end
    
    it "is invalid if content text is longer than 200 characters"
    it "is valid with attachment image"
    it "is invalid if attachment is not image file"
    it "is invalid if any single attachment is larger than 5MB"
    it "is invalid if total attachment size is larger than 20MB"
  end
  
  describe "method::max_rate" do
    it "returns the max rate among the dependent netas average rates" do
      some_topic = create(:topic, user: user_create)
      create(:neta, topic: some_topic, user: user_create, average_rate: 1.25)
      create(:neta, topic: some_topic, user: user_create, average_rate: 2.5)
      create(:neta, topic: some_topic, user: user_create, average_rate: 3)
      create(:neta, topic: some_topic, user: user_create, average_rate: 0)
      create(:neta, topic: some_topic, user: user_create, average_rate: 3.72)
      expect(some_topic.max_rate).to eq 3.72
    end
    it "returns the max rate among the dependent netas average rates where all rates are same" do
      some_topic = create(:topic, user: user_create)
      create(:neta, topic: some_topic, user: user_create, average_rate: 2.5)
      create(:neta, topic: some_topic, user: user_create, average_rate: 2.5)
      create(:neta, topic: some_topic, user: user_create, average_rate: 2.5)
      expect(some_topic.max_rate).to eq 2.5
    end
    it "returns 0 when no netas belong to topic" do
      some_topic = create(:topic, user: user_create)
      expect(some_topic.max_rate).to eq 0
    end
  end

  describe "method::owner(user)" do
    it "returns true when user is author of topic" do
      some_user = create(:user)
      some_topic = create(:topic, user: some_user)
      expect(some_topic.owner(some_user)).to eq true
    end
    it "returns false when user is not author of topic" do
      some_user = create(:user)
      another_user = create(:user)
      some_topic = create(:topic, user: another_user)
      expect(some_topic.owner(some_user)).to eq false
    end
  end
  
  describe "method::editable(user)" do
    it "returns true when user is author of topic and only my neta exists" do
      some_user = create(:user)
      some_topic = create(:topic, user: some_user)
      create(:neta, topic: some_topic, user: some_user)
      expect(some_topic.editable(some_user)).to eq true
    end
    it "returns false when user is author of topic but neta by another user exists" do
      some_user = create(:user)
      another_user = create(:user)
      some_topic = create(:topic, user: some_user)
      create(:neta, topic: some_topic, user: another_user)
      expect(some_topic.editable(some_user)).to eq false
    end
  end
  
  describe "method::potential_interest(user_id)" do
    it "returns true when no bookmark exists on the topic by the user" do
      some_user = create(:user)
      some_topic = create(:topic, user: some_user)
      another_user = create(:user)
      expect(some_topic.potential_interest(another_user.id)).to eq true
    end
    it "returns false when bookmark already exists on the topic by the user" do
      some_user = create(:user)
      some_topic = create(:topic, user: some_user)
      another_user = create(:user)
      create(:interest, interestable: some_topic, user: another_user)
      expect(some_topic.potential_interest(another_user.id)).to eq false
    end
  end
  
  describe "method::add_pageview(user)" do
    it "creates pageview if topic is not viewed by the same user within one day" do
      some_user = create(:user)
      topic = create(:topic, user: some_user)
      another_user = create(:user)
      create(:pageview, pageviewable: topic, user: another_user, created_at: Time.zone.now - 1.day - 1.second)
      expect{topic.add_pageview(another_user)}.to change(Pageview, :count).by(1)
    end
    it "finds pageview if topic is already viewed by the same user within one day" do
      some_user = create(:user)
      topic = create(:topic, user: some_user)
      another_user = create(:user)
      pageview = create(:pageview, pageviewable: topic, user: another_user, created_at: Time.zone.now - 1.day)
      expect(topic.add_pageview(another_user)).to eq pageview
    end
  end
  
  describe "method::is_deleteable" do
    before do
      @some_user = create(:user)
      @topic = create(:topic, user: @some_user)
      @another_user = create(:user)
    end
    it "returns false if neta exists" do
      create(:neta, topic: @topic, user: @another_user)
      expect(@topic.is_deleteable).to eq false
    end
    it "returns true if no dependent data exists" do
      expect(@topic.is_deleteable).to eq true
    end
  end
end
