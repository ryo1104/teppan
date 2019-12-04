require 'rails_helper'

RSpec.describe Interest, type: :model do
  let(:user)      { FactoryBot.create(:user) }
  let(:topic)     { FactoryBot.create(:topic, :with_user) }
  let(:neta)      { FactoryBot.create(:neta, :with_user, topic: topic) }

  describe "Validations" do
    
    it "is valid with a user_id and topic" do
      interest = Interest.new( interestable: topic, user: user )
      expect(interest).to be_valid
    end
    
    it "is valid with a user_id and neta" do
      interest = Interest.new( interestable: neta, user: user )
      expect(interest).to be_valid
    end
  
    it "is invalid without a user_id" do
      interest = Interest.new( interestable: topic, user: nil )
      interest.valid?
      expect(interest.errors[:user]).to include("を入力してください")
    end
  
    it "is invalid without a interestable_id" do
      interest = Interest.new( interestable_type: topic, interestable_id: nil, user: user )
      interest.valid?
      expect(interest.errors[:interestable]).to include("を入力してください")
    end
  
    it "is invalid without a interestable_type" do
      interest = Interest.new( interestable_type: nil, interestable_id: 1, user: user )
      interest.valid?
      expect(interest.errors[:interestable]).to include("を入力してください")
    end
  
    it "is invalid if duplicate interests by same user" do
      Interest.create( interestable: neta, user: user )
      interest = Interest.new( interestable: neta, user: user )
      interest.valid?
      expect(interest.errors[:user_id]).to include("このブックマークはすでに存在します。")
    end
  
  end

end
