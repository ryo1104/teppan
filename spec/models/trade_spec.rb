require 'rails_helper'

RSpec.describe Trade, type: :model do
  let(:user_create)   { FactoryBot.create(:user) }
  let(:topic_create)  { FactoryBot.create(:topic, :with_user) }
  let(:neta_create)   { FactoryBot.create(:neta, :with_user, topic: topic_create) }
  let(:review_create) { FactoryBot.create(:review, :with_user, neta: neta_create) }

  describe 'Validations' do
    it 'is valid with a tradeable, buyer_id, seller_id, stripe_ch_id and price' do
      trade = build(:trade, tradeable: neta_create)
      expect(trade).to be_valid
    end

    it 'is invalid without a tradeable' do
      trade = build(:trade, tradeable: nil)
      trade.valid?
      expect(trade.errors[:tradeable]).to include('を入力してください')
    end

    it 'is invalid without a buyer_id' do
      trade = build(:trade, tradeable: neta_create, buyer_id: nil)
      trade.valid?
      expect(trade.errors[:buyer_id]).to include('を入力してください。')
    end

    it 'is invalid without a seller_id' do
      trade = build(:trade, tradeable: neta_create, seller_id: nil)
      trade.valid?
      expect(trade.errors[:seller_id]).to include('を入力してください。')
    end

    it 'is invalid without a Stripe charge id' do
      trade = build(:trade, tradeable: neta_create, stripe_ch_id: nil)
      trade.valid?
      expect(trade.errors[:stripe_ch_id]).to include('を入力してください。')
    end

    it 'is invalid if Stripe charge id does not start with ch_' do
      trade = build(:trade, tradeable: neta_create, stripe_ch_id: "aaa#{Faker::Lorem.characters(number: 24)}")
      trade.valid?
      expect(trade.errors[:stripe_ch_id]).to include('が正しくありません。')
    end

    it 'is invalid without a price' do
      trade = build(:trade, tradeable: neta_create, price: nil)
      trade.valid?
      expect(trade.errors[:price]).to include('を入力してください。')
    end

    it 'is invalid if price is negative' do
      trade = build(:trade, tradeable: neta_create, price: -1)
      trade.valid?
      expect(trade.errors[:price]).to include('は0以上の値にしてください。')
    end

    it 'is invalid if price is not integer' do
      trade = build(:trade, tradeable: neta_create, price: 100.5)
      trade.valid?
      expect(trade.errors[:price]).to include('は整数で入力してください。')
    end

    it 'is invalid if price is greater than 10000' do
      trade = build(:trade, tradeable: neta_create, price: 10_001)
      trade.valid?
      expect(trade.errors[:price]).to include('は10000以下の値にしてください。')
    end

    it 'is invalid if duplicate trades' do
      create(:trade, tradeable: neta_create, buyer_id: 1, seller_id: 2)
      trade = build(:trade, tradeable: neta_create, buyer_id: 1, seller_id: 2)
      trade.valid?
      expect(trade.errors[:buyer_id]).to include('売買記録はすでに存在します。')
    end
  end

  describe 'method::get_seller_revenue(amount)' do
    it 'returns sellers amount with platform fee deducted' do
      expect(Trade.get_seller_revenue(100)).to eq 75
    end
    it 'returns error when amount is nil' do
      expect { Trade.get_seller_revenue(nil) }.to raise_error(ArgumentError, 'total_amount is nil.')
    end
    it 'returns error when amount is non integer' do
      expect { Trade.get_seller_revenue('60') }.to raise_error(ArgumentError, 'total_amount is not a integer.')
    end
  end

  describe 'method::get_ctax(amount)' do
    it 'returns ctax amount' do
      expect(Trade.get_ctax(60)).to eq 6
    end
    it 'returns error when amount is nil' do
      expect { Trade.get_ctax(nil) }.to raise_error(ArgumentError, 'amount is nil.')
    end
    it 'returns error when amount is non integer' do
      expect { Trade.get_ctax('60') }.to raise_error(ArgumentError, 'amount is not a integer.')
    end
  end
  describe 'method::get_checkout_session'
  describe 'method::process_event'
  describe 'method::update_customer_id'
  describe 'method::fulfill_order'
  describe 'method::get_trade_params'
  describe 'method::get_seller_info'
  describe 'method::get_buyer_info'
  describe 'method::get_neta_id'
  describe 'method::create_trade_amounts'
  describe 'method::get_trades_info'

  # describe 'method::get_trades_info' do
  #   before do
  #     @topic1 = create(:topic, :with_user)
  #     @topic2 = create(:topic, :with_user)
  #     @topic3 = create(:topic, :with_user)
  #     @user1 = create(:user)
  #     @user2 = create(:user)
  #     @user3 = create(:user)
  #     @neta1 = create(:neta, :with_valuecontent, user: @user1, topic: @topic1)
  #     @neta2 = create(:neta, :with_valuecontent, user: @user2, topic: @topic1)
  #     @neta3 = create(:neta, :with_valuecontent, user: @user1, topic: @topic2)
  #     @neta4 = create(:neta, :with_valuecontent, user: @user2, topic: @topic2)
  #     @neta5 = create(:neta, :with_valuecontent, user: @user1, topic: @topic3)
  #     @neta6 = create(:neta, :with_valuecontent, user: @user2, topic: @topic3)
  #     @neta7 = create(:neta, :with_valuecontent, user: @user3, topic: @topic3)
  #   end
  #   context 'when no sold netas exist for user' do
  #     before do
  #       @trade1 = create(:trade, tradeable: @neta6, seller_id: @user2.id, buyer_id: @user1.id)
  #       @trade2 = create(:trade, tradeable: @neta7, seller_id: @user3.id, buyer_id: @user2.id)
  #     end
  #     it 'returns false' do
  #       expect(@user1.get_sold_netas_info).to eq [false, "No sold netas found for user_id #{@user1.id}"]
  #     end
  #   end
  #   context 'when sold netas exist for user' do
  #     before do
  #       @trade1 = create(:trade, tradeable: @neta3, seller_id: @user1.id, buyer_id: @user3.id)
  #       @trade2 = create(:trade, tradeable: @neta5, seller_id: @user1.id, buyer_id: @user2.id)
  #       @trade3 = create(:trade, tradeable: @neta6, seller_id: @user2.id, buyer_id: @user1.id)
  #       @trade4 = create(:trade, tradeable: @neta7, seller_id: @user3.id, buyer_id: @user2.id)
  #     end
  #     it 'returns sold netas' do
  #       sold_netas_info = [
  #         { 'traded_at' => @trade1.created_at, 'title' => @neta3.title, 'price' => @trade1.price, 'buyer_id' => @user3.id, 'buyer_nickname' => @user3.nickname, 'review_rate' => nil },
  #         { 'traded_at' => @trade2.created_at, 'title' => @neta5.title, 'price' => @trade2.price, 'buyer_id' => @user2.id, 'buyer_nickname' => @user2.nickname, 'review_rate' => nil }
  #       ]
  #       expect(@user1.get_sold_netas_info).to eq [true, sold_netas_info]
  #     end
  #   end
  # end
end
