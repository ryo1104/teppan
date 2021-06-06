# frozen_string_literal: true

class StripeExtAccountForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include StripeUtils

  attribute   :bank_name,           :string # 銀行名
  attribute   :branch_name,         :string # 支店名
  attribute   :account_number,      :string # 口座番号
  attribute   :account_holder_name, :string # 口座名義

  validate    :bank_and_branch_name_check
  validates   :account_number,      presence: true, length: { is: 7 }
  validates   :account_holder_name, presence: true, format: { with: /\A[\p{katakana}\p{blank}ー－]+\z/, message: 'はカタカナで入力して下さい。' }

  def bank_and_branch_name_check
    if bank_name.present?
      bank = Bank.find_by(name: bank_name)
      if bank.present?
        if branch_name.present?
          branch = bank.branches.find_by(name: branch_name)
          if branch.present?
            true
          else
            errors.add(:branch_name, :not_found)
            false
          end
        else
          errors.add(:branch_name, :blank)
          false
        end
      else
        errors.add(:bank_name, :not_found)
        false
      end
    else
      errors.add(:bank_name, :blank)
      false
    end
  end

  def create_bank_inputs
    return [false, 'invalid bank or branch name'] unless bank_and_branch_name_check

    bank = Bank.find_by(name: bank_name)
    branch = bank.branches.find_by(name: branch_name)
    stripe_bank_info = {
      external_account:
      {
        object: 'bank_account',
        account_number: account_number,
        routing_number: bank.code.to_s + branch.code.to_s, # 銀行コード4けた+支店コード3けた
        account_holder_name: account_holder_name, # カタカナでなければStripeエラー
        currency: 'jpy',
        country: 'jp'
      },
      default_for_currency: 'true'
    }
    [true, stripe_bank_info]
  end
end
