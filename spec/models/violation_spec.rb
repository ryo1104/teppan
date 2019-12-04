require 'rails_helper'

RSpec.describe Violation, type: :model do
  let(:user)  { FactoryBot.create(:user) }

  describe "Validations" do
    
    it "is valid with a user_id, reporter_id, and block flag" do
      violation = build(:violation, :with_user)
      expect(violation).to be_valid
    end
    
    it "is invalid without a user" do
      violation = build(:violation)
      violation.valid?
      expect(violation.errors[:user]).to include("を入力してください")
    end
  
    it "is invalid without a reporter_id" do
      violation = build(:violation, :with_user, reporter_id: nil)
      violation.valid?
      expect(violation.errors[:reporter_id]).to include("を入力してください。")
    end
  
    it "is invalid if reporter_id is not integer" do
      violation = build(:violation, :with_user, reporter_id: "A")
      violation.valid?
      expect(violation.errors[:reporter_id]).to include("は数値で入力してください。")
    end
    
    it "is invalid with a duplicate pair of user_id and reporter_id" do
      create(:violation, user: user, reporter_id: 100)
      violation = build(:violation, user: user, reporter_id: 100)
      violation.valid?
      expect(violation.errors[:user_id]).to include("この通報はすでに存在します。")
    end
    
    it "is invalid if block is blank" do
      violation = build(:violation, :with_user, block: nil)
      violation.valid?
      expect(violation.errors[:block]).to include("は一覧にありません。")
    end
    
    it "is invalid if block is non boolean" do
      violation = build(:violation, :with_user, block: 2)
      violation.valid?
      expect(violation.errors[:block]).to include("は一覧にありません。")
    end
    
    it "is valid if block is false boolean" do
      violation = build(:violation, :with_user, block: false)
      expect(violation).to be_valid
    end
  
    it "is valid if text is blank" do
      violation = build(:violation, :with_user, text: nil)
      expect(violation).to be_valid
    end
  
    it "is invalid if text is longer than 400 characters" do
      violation = build(:violation, :with_user, text: Faker::Lorem.characters(number: 401) )
      violation.valid?
      expect(violation.errors[:text]).to include("は400文字以内で入力してください。")
    end
    
  end

end
