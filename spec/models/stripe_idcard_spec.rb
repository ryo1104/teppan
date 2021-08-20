require 'rails_helper'

RSpec.describe StripeIdcard, type: :model do
  let(:blank_verify_doc) do
    {
      individual: {
        verification: {
          document: {
            back: nil
          }
        }
      }
    }
  end

  let(:valid_verify_doc) do
    {
      individual: {
        verification: {
          document: {
            front: 'file_vgs9f16rl3qpbmx35or0yhkx'
          }
        }
      }
    }
  end

  describe 'Validations' do
    before do
      @stripe_acct = create(:stripe_account)
    end
    it 'is valid with a stripe_account_id' do
      idcard = build(:stripe_idcard, stripe_account: @stripe_acct)
      expect(idcard).to be_valid
    end
    it 'is invalid without a stripe_account_id' do
      idcard = build(:stripe_idcard, stripe_account: nil)
      idcard.valid?
      expect(idcard.errors[:stripe_account]).to include('を入力してください')
    end
    it 'is invalid if stripe_file_id does not start with file_' do
      idcard = build(:stripe_idcard, stripe_account: @stripe_acct, stripe_file_id: "aaaa_#{Faker::Lorem.characters(number: 24)}")
      idcard.valid?
      expect(idcard.errors[:stripe_file_id]).to include('stripe_file_id does not start with file_')
    end
    it 'is invalid if duplicate frontback with same stripe_account_id' do
      create(:stripe_idcard, stripe_account: @stripe_acct, frontback: 'front')
      idcard = build(:stripe_idcard, stripe_account: @stripe_acct, frontback: 'front')
      idcard.valid?
      expect(idcard.errors[:stripe_account]).to include('に重複した情報がすでにあります。')
    end
    it 'is valid if different frontback with same stripe_account_id' do
      create(:stripe_idcard, stripe_account: @stripe_acct, frontback: 'front')
      idcard = build(:stripe_idcard, stripe_account: @stripe_acct, frontback: 'back')
      expect(idcard).to be_valid
    end
  end

  describe 'method::verification_docs' do
    subject { @idcard.verification_docs }
    it 'returns nil if stripe_file_id is nil' do
      @idcard = build(:stripe_idcard, stripe_file_id: nil, stripe_account: create(:stripe_account), frontback: 'back')
      expect(subject).to eq blank_verify_doc
    end
    it 'returns hash if stripe_file_id exists' do
      @idcard = build(:stripe_idcard, stripe_file_id: 'file_vgs9f16rl3qpbmx35or0yhkx', stripe_account: create(:stripe_account), frontback: 'front')
      expect(subject).to eq valid_verify_doc
    end
  end
end
