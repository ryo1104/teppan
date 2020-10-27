class StripeAccount < ApplicationRecord
  include StripeUtils

  belongs_to  :user
  has_many    :stripe_idcards, dependent: :destroy
  has_many    :stripe_payouts, dependent: :destroy
  validates   :user_id, presence: true, uniqueness: true
  validates   :acct_id, uniqueness: { case_sensitive: true }, allow_nil: true
  validate    :acct_id_check
  validate    :ext_acct_id_check

  # custom validation
  def acct_id_check
    if acct_id.present?
      errors.add(:acct_id, 'acct_id does not start with acct_') unless acct_id.starts_with? 'acct_'
    end
  end

  def ext_acct_id_check
    if ext_acct_id.present?
      errors.add(:ext_acct_id, 'ext_acct_id does not start with ba_') unless ext_acct_id.starts_with? 'ba_'
    end
  end

  def get_connect_account
    return [false, 'acct_id is blank'] if acct_id.blank?

    begin
      stripe_account_obj = JSON.parse(Stripe::Account.retrieve(acct_id).to_s)
    rescue StandardError => e
      ErrorUtility.log_and_notify e
      return [false, "Stripe error - #{e.message}"]
    end
    account_info = StripeAccountForm.parse_account_info(stripe_account_obj)
    if account_info[0]
      [true, account_info[1]]
    else
      [false, "error in parse_account_info : #{account_info[1]}"]
    end
  end

  def self.create_connect_account(account_form, remote_ip)
    stripe_inputs = StripeAccountForm.create_inputs(account_form, remote_ip, 'create')
    begin
      stripe_account_obj = JSON.parse(Stripe::Account.create(stripe_inputs).to_s)
    rescue StandardError => e
      ErrorUtility.log_and_notify e
      return [false, "Stripe error - #{e.message}"]
    end
    account_info = StripeAccountForm.parse_account_info(stripe_account_obj)
    if account_info[0]
      [true, account_info[1]]
    else
      [false, account_info[1]]
    end
  end

  def update_connect_account(account_form, remote_ip)
    return [false, 'acct_id is blank'] if acct_id.blank?

    stripe_inputs = StripeAccountForm.create_inputs(account_form, remote_ip, 'update')
    begin
      stripe_account_obj = JSON.parse(Stripe::Account.update(acct_id, stripe_inputs).to_s)
    rescue StandardError => e
      ErrorUtility.log_and_notify e
      return [false, "Stripe error - #{e.message}"]
    end
    account_info = StripeAccountForm.parse_account_info(stripe_account_obj)
    if account_info[0]
      [true, account_info[1]]
    else
      [false, account_info[1]]
    end
  end

  def delete_connect_account
    return [false, 'acct_id is blank'] if acct_id.blank?
    return [false, 'balance still remains on the account'] unless zero_balance

    begin
      deleted_stripe_account = JSON.parse(Stripe::Account.delete(acct_id).to_s)
    rescue StandardError => e
      ErrorUtility.log_and_notify e
      return [false, "Stripe error - #{e.message}"]
    end
    if deleted_stripe_account['deleted']
      [true, { 'account' => deleted_stripe_account }]
    else
      [false, 'account was not deleted for some reason']
    end
  end

  def get_balance
    return [false, 'acct_id is blank'] if acct_id.blank?

    begin
      stripe_balance_obj = JSON.parse(Stripe::Balance.retrieve({ stripe_account: acct_id }).to_s)
    rescue StandardError => e
      ErrorUtility.log_and_notify e
      return [false, "Stripe error - #{e.message}"]
    end
    check_results = StripeAccountForm.check_results(stripe_balance_obj)
    if check_results[0]
      [true, stripe_balance_obj]
    else
      [false, check_results[1]]
    end
  end

  def zero_balance
    balance_res = get_balance
    return false unless balance_res[0]

    balance_hash = balance_res[1]
    available_bal = balance_hash['available'][0]['amount'].presence || 0
    pending_bal = balance_hash['pending'][0]['amount'].presence || 0
    if available_bal == 0 && pending_bal == 0
      true
    else
      false
    end
  end

  def get_ext_account
    return [false, 'acct_id is blank'] if acct_id.blank?

    begin
      stripe_account_obj = JSON.parse(Stripe::Account.retrieve(acct_id).to_s)
    rescue StandardError => e
      return [false, "Stripe error - #{e.message}"]
    end
    bank_info = Bank.parse_bank_info(stripe_account_obj)
    if bank_info[0]
      [true, bank_info[1]]
    else
      [false, "error in parse_bank_info : #{bank_info[1]}"]
    end
  end

  def create_ext_account(stripe_bank_inputs)
    return [false, 'stripe_bank_inputs is blank'] if stripe_bank_inputs.blank?
    return [false, 'acct_id is blank'] if acct_id.blank?

    begin
      res = JSON.parse(Stripe::Account.create_external_account(acct_id, stripe_bank_inputs).to_s)
      if res.key?('id')
        [true, res]
      else
        [false, 'Failed to create external account']
      end
    rescue StandardError => e
      [false, "Stripe create_external_account error - #{e.message}"]
    end
  end

  def delete_ext_account(old_stripe_bank_id)
    return [false, 'acct_id is blank'] if acct_id.blank?
    return [false, 'ext_acct_id is blank'] if ext_acct_id.blank?

    begin
      res = JSON.parse(Stripe::Account.delete_external_account(acct_id, old_stripe_bank_id).to_s)
      if res.key?('deleted') && res['deleted'] == true
        [true, res]
      else
        [false, 'Failed to delete external account']
      end
    rescue StandardError => e
      [false, "Stripe error - #{e.message}"]
    end
  end

  def find_idcards
    cards = stripe_idcards
    frontcard = cards.find_by(frontback: 'front')
    backcard = cards.find_by(frontback: 'back')
    [frontcard, backcard]
  end
end
