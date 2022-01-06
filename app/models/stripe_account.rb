# frozen_string_literal: true

class StripeAccount < ApplicationRecord
  include StripeUtils

  belongs_to  :user
  has_many    :stripe_idcards, dependent: :destroy
  has_many    :stripe_payouts, dependent: :destroy
  validates   :user_id, uniqueness: true
  validates   :acct_id, uniqueness: { case_sensitive: true }, allow_nil: true
  validate    :acct_id_check
  validate    :ext_acct_id_check

  # custom validation
  def acct_id_check
    errors.add(:acct_id, 'acct_id does not start with acct_') if acct_id.present? && !(acct_id.starts_with? 'acct_')
  end

  def ext_acct_id_check
    errors.add(:ext_acct_id, 'ext_acct_id does not start with ba_') if ext_acct_id.present? && !(ext_acct_id.starts_with? 'ba_')
  end

  def get_connect_account
    return [false, 'acct_id is blank'] if acct_id.blank?

    begin
      stripe_account_obj = JSON.parse(Stripe::Account.retrieve(acct_id).to_s)
    rescue StandardError => e
      ErrorUtility.log_and_notify(exc: e, data: { 'object' => inspect })
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
    stripe_inputs = account_form.create_inputs(remote_ip, 'create')
    begin
      stripe_account_obj = JSON.parse(Stripe::Account.create(stripe_inputs).to_s)
    rescue StandardError => e
      ErrorUtility.log_and_notify(exc: e, data: { 'object' => account_form.inspect, 'remote_ip' => remote_ip })
      return [false, "Stripe error - #{e.message}"]
    end
    account_info = StripeAccountForm.parse_account_info(stripe_account_obj)
    if account_info[0]
      [true, account_info[1]]
    else
      Stripe::Account.delete(stripe_account_obj['id']) if stripe_account_obj.key?('id')
      [false, "error in parse_account_info : #{account_info[1]}"]
    end
  end

  def update_connect_account(account_form, remote_ip)
    return [false, 'acct_id is blank'] if acct_id.blank?

    stripe_inputs = account_form.create_inputs(remote_ip, 'update')
    begin
      stripe_account_obj = JSON.parse(Stripe::Account.update(acct_id, stripe_inputs).to_s)
    rescue StandardError => e
      ErrorUtility.log_and_notify(exc: e, data: { 'object' => inspect, 'stripe_inputs' => stripe_inputs })
      return [false, "Stripe error - #{e.message}"]
    end
    account_info = StripeAccountForm.parse_account_info(stripe_account_obj)
    if account_info[0]
      [true, account_info[1]]
    else
      [false, "error in parse_account_info : #{account_info[1]}"]
    end
  end

  def delete_connect_account
    return [false, 'acct_id is blank'] if acct_id.blank?
    return [false, 'balance still remains on the account'] unless zero_balance

    begin
      deleted_stripe_account = JSON.parse(Stripe::Account.delete(acct_id).to_s)
    rescue StandardError => e
      ErrorUtility.log_and_notify(exc: e, data: { 'object' => inspect })
      return [false, "Stripe error - #{e.message}"]
    end
    if deleted_stripe_account['deleted']
      if update(status: 'deleted')
        [true, { 'account' => deleted_stripe_account }]
      else
        [false, 'account status was not updated']
      end
    else
      [false, 'account was not deleted for some reason']
    end
  end

  def get_balance
    return [false, 'acct_id is blank'] if acct_id.blank?

    begin
      stripe_balance_obj = JSON.parse(Stripe::Balance.retrieve({ stripe_account: acct_id }).to_s)
    rescue StandardError => e
      ErrorUtility.log_and_notify(exc: e, data: { 'object' => inspect })
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
    available_bal.zero? && pending_bal.zero?
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
    rescue StandardError => e
      [false, "Stripe error - #{e.message}"]
    end

    if res.present?
      if res.key?('id')
        [true, res]
      else
        [false, 'Failed to create external account']
      end
    else
      [false, 'Stripe returned nil']
    end
  end

  def delete_ext_account(target_stripe_bank_id)
    return [false, 'acct_id is blank'] if acct_id.blank?
    return [false, 'ext_acct_id is blank'] if ext_acct_id.blank?

    check_default_acct = not_default_ext_acct(target_stripe_bank_id)
    return [false, check_default_acct[1]] unless check_default_acct[0]

    begin
      res = JSON.parse(Stripe::Account.delete_external_account(acct_id, target_stripe_bank_id).to_s)
    rescue StandardError => e
      [false, "Stripe error - #{e.message}"]
    end

    return [false, 'Stripe returned nil'] if res.blank?

    if res.key?('deleted') && res['deleted'] == true
      [true, res]
    else
      [false, 'Failed to delete external account']
    end
  end

  private

  def not_default_ext_acct(old_stripe_bank_id)
    bank_accounts = JSON.parse(Stripe::Account.list_external_accounts(acct_id, { limit: 10, object: 'bank_account' }).to_s)
    if bank_accounts.key?('object') && bank_accounts['object'] == 'list'
      bank_accounts['data'].each do |bank_acct|
        if bank_acct['id'] == old_stripe_bank_id
          if bank_acct['default_for_currency']
            return [false, "this ext_acct #{old_stripe_bank_id} is the default account so it cannot be deleted."]
          else
            return [true, bank_acct['id']]
          end
        end
      end
      [false, "ext_acct #{old_stripe_bank_id} is not registered with this connect account"]
    else
      [false, 'empty list from stripe']
    end
  end
end
