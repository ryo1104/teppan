require 'rails_helper'

RSpec.describe StripeAccount, type: :model do

  let(:account_create)        { create(:stripe_account) }
  let(:stripe_test_key)       { ENV['STRIPE_SECRET_KEY'] }
  let(:valid_payout_result) do 
    { 
      "id"=>"po_1I40cmEyhQyqSyxVsvkfl7Qp", "object"=>"payout", "amount"=>106, "arrival_date"=>1609804800, "automatic"=>false, "balance_transaction"=>"txn_1I40cmEyhQyqSyxVRBa0OnTO", "created"=>1609319144, "currency"=>"jpy", "description"=>nil, "destination"=>"ba_1HdBXBEyhQyqSyxVwE4ZZBJ6", "failure_balance_transaction"=>nil, "failure_code"=>nil, "failure_message"=>nil, "livemode"=>false, "metadata"=>{}, "method"=>"standard", "original_payout"=>nil, "reversed_by"=>nil, "source_type"=>"card", "statement_descriptor"=>nil, "status"=>"pending", "type"=>"bank_account" 
    }
  end
  
  describe 'Validations' do
    it 'is valid with a stripe_account_id, payout_id, amount' do
      payout = build(:stripe_payout, stripe_account: account_create)
      expect(payout).to be_valid
    end

    it 'is invalid without a stripe_account_id' do
      payout = build(:stripe_payout, stripe_account: nil)
      payout.valid?
      expect(payout.errors[:stripe_account]).to include 'を入力してください'
    end
    
    it 'is invalid without a payout_id' do
      payout = build(:stripe_payout, payout_id: nil)
      payout.valid?
      expect(payout.errors[:payout_id]).to include 'を入力してください。'
    end
    
    it 'is invalid if payout_id does not start with po_' do
      payout = build(:stripe_payout, payout_id: 'aaaa_' + Faker::Lorem.characters(number: 16))
      payout.valid?
      expect(payout.errors[:payout_id]).to include('payout_id does not start with po_')
    end

    it 'is invalid with a duplicate payout_id' do
      create(:stripe_payout, payout_id: 'po_abcdeFGHIJ123456')
      payout = build(:stripe_payout, payout_id: 'po_abcdeFGHIJ123456')
      payout.valid?
      expect(payout.errors[:payout_id]).to include('はすでに存在します。')
    end
    
    it 'is invalid without a amount' do
      payout = build(:stripe_payout, amount: nil)
      payout.valid?
      expect(payout.errors[:amount]).to include 'を入力してください。'
    end

    it 'is invalid with a negative amount' do
      payout = build(:stripe_payout, amount: -1)
      payout.valid?
      expect(payout.errors[:amount]).to include 'は0以上の値にしてください。'
    end

    it 'is invalid with a non-integer amount' do
      payout = build(:stripe_payout, amount: 0.5)
      payout.valid?
      expect(payout.errors[:amount]).to include 'は整数で入力してください。'
    end

  end
  
  describe 'method::create_stripe_payout' do
    before do
      Stripe.api_key = stripe_test_key
      allow(Stripe::Payout).to receive(:create).and_return(valid_payout_result.to_json)
    end
    context 'successfully' do
      it 'creates Stripe payout' do
        @result = StripePayout.create_stripe_payout(100, 'acct_abcde')
        expect(@result).to eq [true, valid_payout_result]
      end
    end
    context 'fails and' do
      it 'returns false when amount is blank' do
        @result = StripePayout.create_stripe_payout(nil, 'acct_abcde')
        expect(@result).to eq [false, 'amount is blank']
      end
      it 'returns false when amount is non integer' do
        @result = StripePayout.create_stripe_payout(0.1, 'acct_abcde')
        expect(@result).to eq [false, 'amount is non integer']
      end
      it 'returns false when amount is zero' do
        @result = StripePayout.create_stripe_payout(0, 'acct_abcde')
        expect(@result).to eq [false, 'amount is zero or negative : 0']
      end
      it 'returns false when amount is negative' do
        @result = StripePayout.create_stripe_payout(-1, 'acct_abcde')
        expect(@result).to eq [false, 'amount is zero or negative : -1']
      end
      it 'returns false when acct_id is blank' do
        @result = StripePayout.create_stripe_payout(10, '')
        expect(@result).to eq [false, 'acct_id is blank']
      end
      it 'returns false when acct_id does not start with acct_' do
        @result = StripePayout.create_stripe_payout(10, 'act_abcde')
        expect(@result).to eq [false, 'acct_id is invalid : act_abcde']
      end
    end
  end

end