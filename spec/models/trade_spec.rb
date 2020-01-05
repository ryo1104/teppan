require 'rails_helper'

RSpec.describe Trade, type: :model do
  let(:user_create)   { FactoryBot.create(:user) }
  let(:topic_create)  { FactoryBot.create(:topic, :with_user) }
  let(:neta_create)   { FactoryBot.create(:neta, :with_user, topic: topic_create) }
  let(:review_create) { FactoryBot.create(:review, :with_user, neta: neta_create) }
  
  describe "Validations" do
    
    it "is valid with a tradeable, buyer_id, seller_id, stripe_charge_id and price" do
      trade = build(:trade, tradeable: neta_create)
      expect(trade).to be_valid
    end
    
    it "is invalid without a tradeable" do
      trade = build(:trade, tradeable: nil)
      trade.valid?
      expect(trade.errors[:tradeable]).to include("を入力してください")
    end
  
    it "is invalid without a buyer_id" do
      trade = build(:trade, tradeable: neta_create, buyer_id: nil)
      trade.valid?
      expect(trade.errors[:buyer_id]).to include("を入力してください。")
    end
  
    it "is invalid without a seller_id" do
      trade = build(:trade, tradeable: neta_create, seller_id: nil)
      trade.valid?
      expect(trade.errors[:seller_id]).to include("を入力してください。")
    end
  
    it "is invalid without a stripe_charge_id" do
      trade = build(:trade, tradeable: neta_create, stripe_charge_id: nil)
      trade.valid?
      expect(trade.errors[:stripe_charge_id]).to include("blank stripe_charge_id")
    end
  
    it "is invalid if stripe_charge_id does not start with ch_" do
      trade = build(:trade, tradeable: neta_create, stripe_charge_id: "aaa"+Faker::Lorem.characters(number: 24))
      trade.valid?
      expect(trade.errors[:stripe_charge_id]).to include("invalid stripe_charge_id")
    end
  
    it "is invalid without a price" do
      trade = build(:trade, tradeable: neta_create, price: nil)
      trade.valid?
      expect(trade.errors[:price]).to include("を入力してください。")
    end
    
    it "is invalid if price is negative" do
      trade = build(:trade, tradeable: neta_create, price: -1)
      trade.valid?
      expect(trade.errors[:price]).to include("は0以上の値にしてください。")
    end
    
    it "is invalid if price is not integer" do
      trade = build(:trade, tradeable: neta_create, price: 100.5)
      trade.valid?
      expect(trade.errors[:price]).to include("は整数で入力してください。")
    end
    
    it "is invalid if price is greater than 10000" do
      trade = build(:trade, tradeable: neta_create, price: 10001)
      trade.valid?
      expect(trade.errors[:price]).to include("は10000以下の値にしてください。")
    end
  
    it "is invalid if duplicate trades" do
      create(:trade, tradeable: neta_create, buyer_id: 1, seller_id: 2)
      trade = build(:trade, tradeable: neta_create, buyer_id: 1, seller_id: 2)
      trade.valid?
      expect(trade.errors[:buyer_id]).to include("重複した取引情報が存在しています。")
    end
  
  end

  describe "method::get_ctax(amount)" do
    it "returns ctax amount" do
      expect(Trade.get_ctax(60)).to eq 4
    end
    it "returns error when amount is nil" do
      expect{Trade.get_ctax(nil)}.to raise_error(ArgumentError, "入力値がありません。")
    end
    it "returns error when amount is non integer" do
      expect{Trade.get_ctax("60")}.to raise_error(ArgumentError, "入力値が整数ではありません。")
    end
  end
  
  describe "method::charge" do
    it "creates charge transaction in Stripe"
  end
end