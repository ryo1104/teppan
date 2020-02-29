require 'rails_helper'

RSpec.describe Neta, type: :model do
  let(:user_create)   { FactoryBot.create(:user) }
  let(:topic_create)  { FactoryBot.create(:topic, :with_user) }
  
  describe "Validations" do
    
    it "is valid with a user_id, topic_id, text, and price" do
      neta = build(:neta, user: user_create, topic: topic_create)
      expect(neta).to be_valid
    end
    
    it "is invalid without a user" do
      neta = build(:neta, user: nil, topic: topic_create)
      neta.valid?
      expect(neta.errors[:user]).to include("を入力してください")
    end
  
    it "is invalid without a topic" do
      neta = build(:neta, user: user_create, topic: nil)
      neta.valid?
      expect(neta.errors[:topic]).to include("を入力してください")
    end
    it "is invalid without a title"
    it "is invalid without a content" do
      neta = build(:neta, user: user_create, topic: topic_create, content: nil)
      neta.valid?
      expect(neta.errors[:content]).to include("を入力してください。")
    end
  
    it "is invalid if content is longer than 800 characters" #do
    #   neta = build(:neta, content: Faker::Lorem.characters(number: 801), user: user_create, topic: topic_create)
    #   neta.valid?
    #   expect(neta.errors[:text]).to include("は800文字以内で入力してください。")
    # end
  
    it "is invalid if content is shorter than 20 characters" #do
    #   neta = build(:neta, text: Faker::Lorem.characters(number: 19), user: user_create, topic: topic_create)
    #   neta.valid?
    #   expect(neta.errors[:text]).to include("は20文字以上で入力してください。")
    # end
    
    it "is invalid if introduction is longer than 200 characters" #do
    #   neta = build(:neta, valuetext: Faker::Lorem.characters(number: 801), user: user_create, topic: topic_create)
    #   neta.valid?
    #   expect(neta.errors[:valuetext]).to include("は800文字以内で入力してください。")
    # end
  
    it "is invalid without a price" do
      neta = build(:neta, user: user_create, topic: topic_create, price: nil)
      neta.valid?
      expect(neta.errors[:price]).to include("を入力してください。")
    end
   
    it "is invalid if price is negative" do
      neta = build(:neta, user: user_create, topic: topic_create, price: -1)
      neta.valid?
      expect(neta.errors[:price]).to include("は0以上の値にしてください。")
    end
    
    it "is invalid if price is not integer" do
      neta = build(:neta, user: user_create, topic: topic_create, price: 100.1)
      neta.valid?
      expect(neta.errors[:price]).to include("は整数で入力してください。")
    end
    
    it "is invalid if price is greater than 10000" do
      neta = build(:neta, user: user_create, topic: topic_create, price: 10001)
      neta.valid?
      expect(neta.errors[:price]).to include("は10000以下の値にしてください。")
    end
    
    it "is invalid if private_flag is blank" do
      neta = build(:neta, user: user_create, topic: topic_create, private_flag: nil)
      neta.valid?
      expect(neta.errors[:private_flag]).to include("は一覧にありません。")
    end
    
    it "is valid if private_flag is false boolean" do
      neta = build(:neta, user: user_create, topic: topic_create, private_flag: false)
      expect(neta).to be_valid
    end
    
    it "is invalid if hashtag count is more than 20"
  end
  
  describe "counter_culture" do
    it "increments review count column when child review is created"
    it "decrements review count column when child review is deleted"
  end
  
  describe "method::average_rate(netas)" do
    it "returns average review rate from multiple netas" do
      user = user_create
      topic1 = FactoryBot.create(:topic, :with_user)
      topic2 = FactoryBot.create(:topic, :with_user)
      topic3 = FactoryBot.create(:topic, :with_user)
      create(:neta, user: user, topic: topic1, reviews_count: 4, average_rate: 3.11)
      create(:neta, user: user, topic: topic2, reviews_count: 3, average_rate: 3.72)
      create(:neta, user: user, topic: topic3, reviews_count: 1, average_rate: 0)
      expect(Neta.average_rate(user.netas)).to eq ((3.11*4+3.72*3+0*1)/(4+3+1)).round(2)
    end
    it "returns 0 when no netas by user" do
      user = user_create
      expect(Neta.average_rate(user.netas)).to eq 0
    end
    it "returns 0 when netas exist but with no reviews"
  end
  
  describe "method::update_average_rate" do
    it "updates attribute average_rate with reviews" do
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
      expect(neta.update_average_rate).to eq [false, "no reviews exist for the neta"]
    end
    it "does not update attribute average_rate when no reviews exist" do
      neta = create(:neta, user: user_create, topic: topic_create)
      neta.update_average_rate
      expect(neta.average_rate).to eq 0
    end
    it "returns false when update fails" do
      neta = create(:neta, user: user_create, topic: topic_create)
      create(:review, :with_user, neta: neta, rate: 3)
      create(:review, :with_user, neta: neta, rate: 4)
      allow_any_instance_of(Neta).to receive(:update!).and_return(false)
      expect(neta.update_average_rate).to eq [false, "error updating average_rate"]
    end
  end
  
  describe "method::owner" do
    it "returns true if user is neta owner" do
      some_user = user_create
      neta = create(:neta, user: some_user, topic: topic_create)
      expect(neta.owner(some_user)).to eq true
    end
    
    it "returns false if user is not neta owner" do
      some_user = create(:user)
      another_user = create(:user)
      neta = create(:neta, user: some_user, topic: topic_create)
      expect(neta.owner(another_user)).to eq false
    end
  end
  
  describe "method::editable" do
    it "returns true if no trade exists on the neta" do
      neta = create(:neta, user: user_create, topic: topic_create)
      expect(neta.editable).to eq true
    end

    it "returns false if trade exists on the neta" do
      neta = create(:neta, user: user_create, topic: topic_create)
      create(:trade, tradeable: neta)
      expect(neta.editable).to eq false
    end
  end
  
  describe "method::for_sale" do
    it "returns false if user is not premium user" do
      user = user_create
      neta = create(:neta, user: user, topic: topic_create)
      account = instance_double("Account", stripe_status: "verified")
      allow(user).to receive(:premium_user).and_return([false, nil, nil])
      allow(user).to receive(:account).and_return(account)
      expect(neta.for_sale).to eq false
    end
    it "returns false if user is premium user but account does not exist" do
      user = user_create
      neta = create(:neta, user: user, topic: topic_create)
      allow(user).to receive(:premium_user).and_return([true, nil, nil])
      expect(neta.for_sale).to eq false
    end
    it "returns false if user is premium user and account exists, but account status is not verified" do
      user = user_create
      neta = create(:neta, user: user, topic: topic_create)
      account = instance_double("Account", stripe_status: "unverified")
      allow(user).to receive(:premium_user).and_return([true, nil, nil])
      allow(user).to receive(:account).and_return(account)
      expect(neta.for_sale).to eq false
    end
    
    it "returns true if user is premium user and account status is verified" do
      user = user_create
      neta = create(:neta, user: user, topic: topic_create)
      account = instance_double("Account", stripe_status: "verified")
      allow(user).to receive(:premium_user).and_return([true, nil, nil])
      allow(user).to receive(:account).and_return(account)
      expect(neta.for_sale).to eq true
    end
  end
  
  describe "method::public_str" do
    it "returns 非公開 when private_flag is true" do
      neta = create(:neta, user: user_create, topic: topic_create, private_flag: true)
      expect(neta.public_str).to eq "非公開"
    end
    it "returns 公開 when private_flag is false" do
      neta = create(:neta, user: user_create, topic: topic_create, private_flag: false)
      expect(neta.public_str).to eq "公開"
    end
  end
  
  describe "method::add_pageview" do
    it "creates pageview if neta is not viewed by the same user within one day" do
      some_user = create(:user)
      neta = create(:neta, user: some_user, topic: topic_create)
      another_user = create(:user)
      create(:pageview, pageviewable: neta, user: another_user, created_at: Time.zone.now - 1.day - 1.second)
      expect{neta.add_pageview(another_user)}.to change(Pageview, :count).by(1)
    end
    it "finds pageview if neta is already viewed by the same user within one day" do
      some_user = create(:user)
      neta = create(:neta, user: some_user, topic: topic_create)
      another_user = create(:user)
      pageview = create(:pageview, pageviewable: neta, user: another_user, created_at: Time.zone.now - 1.day)
      expect(neta.add_pageview(another_user)).to eq pageview
    end
  end
  describe "method::has_dependents" do
    it "returns true if review exists" do
      neta = create(:neta, user: user_create, topic: topic_create)
      create(:review, :with_user, neta: neta)
      expect(neta.has_dependents).to eq true
    end
    it "returns true if trade exists" do
      neta = create(:neta, user: user_create, topic: topic_create)
      create(:trade, tradeable: neta)
      expect(neta.has_dependents).to eq true
    end
    it "returns true if pageview exists" do
      neta = create(:neta, user: user_create, topic: topic_create)
      create(:pageview, pageviewable: neta, user: user_create)
      expect(neta.has_dependents).to eq true
    end
    it "returns true if interest exists" do
      neta = create(:neta, user: user_create, topic: topic_create)
      create(:interest, interestable: neta, user: user_create)
      expect(neta.has_dependents).to eq true
    end
    it "returns true if exists in ranking"
    it "returns false if no dependent data exists" do
      neta = create(:neta, user: user_create, topic: topic_create)
      expect(neta.has_dependents).to eq false
    end
  end
  
end
