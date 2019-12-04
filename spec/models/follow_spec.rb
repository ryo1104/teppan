require 'rails_helper'

RSpec.describe Follow, type: :model do
  let(:user)  { FactoryBot.create(:user) }

  describe "Validations" do
    
    it "is valid with a user_id and follower_id" do
      follow = build(:follow, :with_user)
      expect(follow).to be_valid
    end
  
    it "is invalid without a user" do
      follow = build(:follow)
      follow.valid?
      expect(follow.errors[:user]).to include("を入力してください")
    end
  
    it "is invalid without a follower_id" do
      follow = build(:follow, :with_user, follower_id: nil)
      follow.valid?
      expect(follow.errors[:follower_id]).to include("を入力してください。")
    end
  
    it "is invalid if follower_id is not integer" do
      follow = build(:follow, :with_user, follower_id: "A")
      follow.valid?
      expect(follow.errors[:follower_id]).to include("は数値で入力してください。")
    end
  
    it "is invalid with a duplicate pair of user_id and follower_id" do
      follow = create(:follow, user: user, follower_id: 100)
      follow = build(:follow, user: user, follower_id: 100)
      follow.valid?
      expect(follow.errors[:user_id]).to include("このフォローはすでに存在します。")
    end
  
  end

end
