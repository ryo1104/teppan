class StripeExtAccountForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include StripeUtils

  attribute   :bank_name,           :string
  attribute   :branch_name,         :string
  attribute   :account_number,      :string
  attribute   :account_holder_name, :string

  validate    :bank_and_branch_name_check
  validates   :account_number,      presence: true, length: { is: 7 }
  validates   :account_holder_name, presence: true, format: { with: /\A[\p{katakana}\p{blank}ー－]+\z/, message: 'はカタカナで入力して下さい。' }

  def bank_and_branch_name_check
    if bank_name.present?
      bank = Bank.find_by(name: bank_name)
      errors.add(:bank_name, :invalid) unless bank.present?
      if branch_name.present?
        branch = bank.branches.find_by(name: branch_name)
        errors.add(:branch_name, :invalid) unless branch.present?
      else
        errors.add(:branch_name, :blank)
      end
    else
      errors.add(:bank_name, :blank)
    end
  end

  def set_info(bank_info)
    self.bank_name = bank_info['bank_name']
    self.branch_name = bank_info['branch_name']
    self.account_number = bank_info['account_number']
    self.account_holder_name = bank_info['account_holder_name']
  end

  def create_stripe_bank_inputs
    bank = Bank.find_by(name: bank_name)
    branch = bank.branches.find_by(name: branch_name)
    if bank.present? && branch.present?
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
    else
      [false, "cannot retrieve bank #{bank_name} or branch #{branch_name}"]
    end
  end
end
