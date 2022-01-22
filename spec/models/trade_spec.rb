require 'rails_helper'

RSpec.describe Trade, type: :model do
  let(:user_create)   { FactoryBot.create(:user) }
  let(:topic_create)  { FactoryBot.create(:topic, :with_user) }
  let(:neta_create)   { FactoryBot.create(:neta, :with_user, topic: topic_create) }
  let(:review_create) { FactoryBot.create(:review, :with_user, neta: neta_create) }

  describe 'Validations' do
    it 'is valid with a neta, buyer_id, seller_id, stripe_ch_id and price' do
      trade = build(:trade, neta: neta_create)
      expect(trade).to be_valid
    end

    it 'is invalid without a neta' do
      trade = build(:trade, neta: nil)
      trade.valid?
      expect(trade.errors[:neta]).to include('を入力してください')
    end

    it 'is invalid without a buyer_id' do
      trade = build(:trade, neta: neta_create, buyer_id: nil)
      trade.valid?
      expect(trade.errors[:buyer_id]).to include('を入力してください。')
    end

    it 'is invalid without a seller_id' do
      trade = build(:trade, neta: neta_create, seller_id: nil)
      trade.valid?
      expect(trade.errors[:seller_id]).to include('を入力してください。')
    end

    it 'is invalid without a Stripe charge id' do
      trade = build(:trade, neta: neta_create, stripe_ch_id: nil)
      trade.valid?
      expect(trade.errors[:stripe_ch_id]).to include('を入力してください。')
    end

    it 'is invalid if Stripe charge id does not start with ch_' do
      trade = build(:trade, neta: neta_create, stripe_ch_id: "aaa#{Faker::Lorem.characters(number: 24)}")
      trade.valid?
      expect(trade.errors[:stripe_ch_id]).to include('が正しくありません。')
    end

    it 'is invalid without a price' do
      trade = build(:trade, neta: neta_create, price: nil)
      trade.valid?
      expect(trade.errors[:price]).to include('を入力してください。')
    end

    it 'is invalid if price is negative' do
      trade = build(:trade, neta: neta_create, price: -1)
      trade.valid?
      expect(trade.errors[:price]).to include('は0以上の値にしてください。')
    end

    it 'is invalid if price is not integer' do
      trade = build(:trade, neta: neta_create, price: 100.5)
      trade.valid?
      expect(trade.errors[:price]).to include('は整数で入力してください。')
    end

    it 'is invalid if price is greater than 10000' do
      trade = build(:trade, neta: neta_create, price: 10_001)
      trade.valid?
      expect(trade.errors[:price]).to include('は10000以下の値にしてください。')
    end

    it 'is invalid if duplicate trades' do
      create(:trade, neta: neta_create, buyer_id: 1, seller_id: 2)
      trade = build(:trade, neta: neta_create, buyer_id: 1, seller_id: 2)
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
  describe 'method::execute_order'
  describe 'method::get_trade_params'
  describe 'method::get_seller_info'
  describe 'method::get_buyer_info'
  describe 'method::get_neta_info'
  describe 'method::parse_trade_amounts'
  describe 'method::get_trades_info', type: :doing do
    before do
      @seller = FactoryBot.create(:user)
      @buyer1 = FactoryBot.create(:user)
      @buyer2 = FactoryBot.create(:user)
      @topic = FactoryBot.create(:topic, user: @buyer1)
      @neta = FactoryBot.create(:neta, :with_valuecontent, user: @seller, topic: @topic)
      @trade1 = FactoryBot.create(:trade, neta: @neta, buyer_id: @buyer1.id, seller_id: @seller.id)
      @trade2 = FactoryBot.create(:trade, neta: @neta, buyer_id: @buyer2.id, seller_id: @seller.id)
      @review2 = FactoryBot.create(:review, neta: @neta, user: @buyer2)
    end
    it 'returns trade details for given seller id' do
      expected_result = [true, [{ 'traded_at' => @trade1.created_at, 'neta_id' => @neta.id, 'title' => @neta.title, 'price' => @neta.price, 'buyer_id' => @buyer1.id, 'buyer_nickname' => @buyer1.nickname, 'review_rate' => nil }]]
      expect(Trade.get_trades_info('buyer', @buyer1.id)).to eq expected_result
    end
    it 'returns trade details for given buyer id' do
      expected_result = [true,
                         [
                           { 'traded_at' => @trade1.created_at, 'neta_id' => @neta.id, 'title' => @neta.title, 'price' => @neta.price, 'buyer_id' => @buyer1.id, 'buyer_nickname' => @buyer1.nickname,  'review_rate' => nil },
                           { 'traded_at' => @trade2.created_at, 'neta_id' => @neta.id, 'title' => @neta.title, 'price' => @neta.price, 'buyer_id' => @buyer2.id, 'buyer_nickname' => @buyer2.nickname,  'review_rate' => @review2.rate }
                         ]]
      expect(Trade.get_trades_info('seller', @seller.id)).to eq expected_result
    end
    it 'returns false when no trades exist for given user id' do
      expected_result = [false, "No trades found for seller and user_id #{@buyer1.id}"]
      expect(Trade.get_trades_info('seller', @buyer1.id)).to eq expected_result
    end
  end
end
