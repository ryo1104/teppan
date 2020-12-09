FactoryBot.define do
  factory :StripeExtAccountForm do
    bank_name { 'STRIPE TEST BANK' }
    branch_name { 'STRIPE TEST BRANCH' }
    account_number { '0001234' }
    account_holder_name { 'ギンコウタロウ' }
  end
end
