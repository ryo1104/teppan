require 'rails_helper'

RSpec.describe StripeExtAccountForm, type: :model do
  let(:valid_bank_info) do
    { 'bank_name' => 'STRIPE TEST BANK', 'branch_name' => 'STRIPE TEST BRANCH', 'account_number' => '0001234', 'account_holder_name' => 'ギンコウタロウ' }
  end
  let(:valid_stripe_inputs) do
    { external_account: { object: 'bank_account', account_number: '0001234', routing_number: '1100000', account_holder_name: 'ギンコウタロウ', currency: 'jpy', country: 'jp' }, default_for_currency: 'true' }
  end

  describe 'Validations' do
    before do
      test_bank = create(:bank)
      create(:branch, bank: test_bank)
    end
    it 'is invalid without a bank name' do
      form = build(:StripeExtAccountForm, bank_name: nil)
      form.valid?
      expect(form.errors[:bank_name]).to include('を入力してください。')
    end
    it 'is invalid if bank does not exist' do
      form = build(:StripeExtAccountForm, bank_name: 'some bank')
      form.valid?
      expect(form.errors[:bank_name]).to include('が見つかりません。')
    end
    it 'is invalid without a branch name' do
      form = build(:StripeExtAccountForm, branch_name: nil)
      form.valid?
      expect(form.errors[:branch_name]).to include('を入力してください。')
    end
    it 'is invalid if branch for a given bank does not exist' do
      form = build(:StripeExtAccountForm, branch_name: 'some branch')
      form.valid?
      expect(form.errors[:branch_name]).to include('が見つかりません。')
    end
    it 'is invalid without a account number' do
      form = build(:StripeExtAccountForm, account_number: nil)
      form.valid?
      expect(form.errors[:account_number]).to include('を入力してください。')
    end
    it 'is invalid if account number is not 7 digits' do
      form = build(:StripeExtAccountForm, account_number: '00000000')
      form.valid?
      expect(form.errors[:account_number]).to include('は7字で入力してください。')
    end
    it 'is invalid without a account holder name' do
      form = build(:StripeExtAccountForm, account_holder_name: nil)
      form.valid?
      expect(form.errors[:account_holder_name]).to include('を入力してください。')
    end
    it 'is invalid if account holder name is not katakana' do
      form = build(:StripeExtAccountForm, account_holder_name: 'ぎんこうたろう')
      form.valid?
      expect(form.errors[:account_holder_name]).to include('はカタカナで入力して下さい。')
    end
  end

  describe 'method::create_bank_inputs' do
    before do
      bank = create(:bank)
      create(:branch, bank: bank)
    end
    it 'generates a input for stripe' do
      form = build(:StripeExtAccountForm)
      expect(form.create_bank_inputs).to eq [true, valid_stripe_inputs]
    end
  end
end
