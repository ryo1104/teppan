# frozen_string_literal: true

class Bank < ApplicationRecord
  require 'zengin_code'
  validates :code, presence: true, uniqueness: { case_sensitive: true }
  has_many :branches, dependent: :destroy

  def self.parse_bank_info(stripe_account_obj)
    return [false, 'stripe_account_obj does not exist'] if stripe_account_obj.blank?
    return [false, 'external account info is empty'] unless stripe_account_obj.key?('external_accounts')
    return [false, 'external account data is blank'] if stripe_account_obj['external_accounts']['data'].empty?

    ext_acct = stripe_account_obj['external_accounts']['data'].find { |n| n['default_for_currency'] == true }
    # stripe_account_obj['external_accounts']['data'].map do |ext_acct|
    return [false, 'last4 does not exist'] unless ext_acct.key?('last4')
    return [false, 'account_holder_name does not exist'] unless ext_acct.key?('account_holder_name')

    bank_branch_name = Bank.get_bank_branch_names(ext_acct)
    return [false, bank_branch_name[1]] unless bank_branch_name[0]

    info = { 'bank_name' => bank_branch_name[1][0],
             'branch_name' => bank_branch_name[1][1],
             'account_number' => '***' + ext_acct['last4'],
             'account_holder_name' => ext_acct['account_holder_name'] }
    [true, info]
    # end
  end

  def self.get_bank_branch_names(ext_acct)
    return [false, 'routing number hash does not exist'] unless ext_acct.key?('routing_number')
    return [false, 'routing number does not exist'] if ext_acct['routing_number'].blank?
    return [false, 'routing number is not 7 digits'] unless ext_acct['routing_number'].length == 7

    bank = find_by(code: ext_acct['routing_number'][0, 4])
    return [false, 'unable to retrieve bank from database'] if bank.blank?

    branch = bank.branches.find_by(code: ext_acct['routing_number'][4, 3])
    return [false, 'unable to retrieve branch from database'] if branch.blank?

    [true, [bank.name, branch.name]]
  end

  def self.get_zengin_all
    ZenginCode::Bank.all
  end
end
