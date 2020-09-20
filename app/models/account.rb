class Account < ApplicationRecord
  include StripeUtils

  belongs_to  :user
  has_one     :externalaccount, dependent: :destroy
  has_many    :idcards, dependent: :destroy
  has_many    :payouts, dependent: :destroy
  validates   :user_id, presence: true, uniqueness: true
  validates   :stripe_acct_id, uniqueness: { case_sensitive: true }, allow_nil: true
  validate    :stripe_acct_id_check


  # custom validation
  def stripe_acct_id_check
    if stripe_acct_id.present?
      errors.add(:stripe_acct_id, 'stripe_acct_id does not start with acct_') unless stripe_acct_id.starts_with? 'acct_'
    end
  end

  def get_stripe_account
    if stripe_acct_id
      begin
        stripe_account_obj = JSON.parse(Stripe::Account.retrieve(stripe_acct_id).to_s)
      rescue StandardError => e
        ErrorUtility.log_and_notify e
        return [false, "Stripe error - #{e.message}"]
      end
      account_info = Account.parse_account_info(stripe_account_obj)
      if account_info[0]
        [true, account_info[1]]
      else
        [false, "error in parse_account_info : #{account_info[1]}"]
      end
    else
      [false, 'stripe_acct_id is blank']
    end
  end

  def create_stripe_account(account_form, remote_ip)
    stripe_inputs = stripe_inputs_create(account_form, remote_ip)
    inputs_check = check_stripe_inputs(stripe_inputs, 'create')
    if inputs_check[0]
      begin
        stripe_account_obj = JSON.parse(Stripe::Account.create(stripe_inputs).to_s)
      rescue => e
        ErrorUtility.log_and_notify e
        return [false, "Stripe error - #{e.message}"]
      end
      account_info = Account.parse_account_info(stripe_account_obj)
      if account_info[0] == true
        [true, account_info[1]]
      else
        [false, account_info[1]]
      end
    else
      [false, inputs_check[1]]
    end
  end

  def update_stripe_account(account_form, remote_ip)
    if stripe_acct_id
      stripe_inputs = stripe_inputs_create(account_form, remote_ip)
      inputs_check = check_stripe_inputs(stripe_inputs, 'update')
      if inputs_check[0]
        begin
          stripe_account_obj = JSON.parse(Stripe::Account.update(stripe_acct_id, stripe_inputs).to_s)
        rescue => e
          ErrorUtility.log_and_notify e
          return [false, "Stripe error - #{e.message}"]
        end
        account_info = Account.parse_account_info(stripe_account_obj)
        if account_info[0]
          [true, account_info[1]]
        else
          [false, account_info[1]]
        end
      else
        [false, inputs_check[1]]
      end
    else
      [false, 'stripe_acct_id is blank']
    end
  end

  def delete_stripe_account
    if stripe_acct_id
      if zero_balance
        begin
          deleted_stripe_account = JSON.parse(Stripe::Account.delete(stripe_acct_id).to_s)
        rescue StandardError => e
          ErrorUtility.log_and_notify e
          return [false, "Stripe error - #{e.message}"]
        end
        if deleted_stripe_account['deleted']
          [true, { 'account' => deleted_stripe_account }]
        else
          [false, 'account was not deleted for some reason']
        end
      else
        [false, 'balance still remains on the account']
      end
    else
      [false, 'stripe_acct_id is blank']
    end
  end

  def get_stripe_balance
    if stripe_acct_id
      begin
        stripe_balance_obj = JSON.parse(Stripe::Balance.retrieve({ stripe_account: stripe_acct_id }).to_s)
      rescue StandardError => e
        ErrorUtility.log_and_notify e
        return [false, "Stripe error - #{e.message}"]
      end
      check_results = Account.check_stripe_results(stripe_balance_obj)
      if check_results[0]
        [true, stripe_balance_obj]
      else
        [false, check_results[1]]
      end
    else
      [false, 'stripe_acct_id is blank']
    end
  end

  def zero_balance
    balance_res = get_stripe_balance

    if balance_res[0]
      balance_hash = balance_res[1]

      if balance_hash['available'][0]['amount'].present?
        available_bal = balance_hash['available'][0]['amount']
      else
        available_bal = 0
      end

      if balance_hash['pending'][0]['amount'].present?
        pending_bal = balance_hash['pending'][0]['amount']
      else
        pending_bal = 0
      end

      if available_bal == 0 && pending_bal == 0
        true
      else
        false
      end
    else
      false
    end
  end

  def stripe_inputs_create(account_form, remote_ip)
    ac_params = {
      business_type: 'individual',
      type: 'custom',
      country: 'JP',
      individual: account_form.stripe_inputs_individual
    }
    if account_form.user_agreement
      ac_params.merge!(
        tos_acceptance: {
          date: Time.parse(Time.zone.now.to_s).to_i,
          ip: remote_ip.to_s
        }
      )
    end
    ac_params
  end

  def stripe_inputs_update(account_form, remote_ip)
    ac_params = {
      business_type: 'individual',
      individual: account_form.stripe_inputs_individual
    }
    if account_form.user_agreement
      ac_params.merge!(
        tos_acceptance: {
          date: Time.parse(Time.zone.now.to_s).to_i,
          ip: remote_ip.to_s
        }
      )
    end
    ac_params
  end

  def check_stripe_inputs(account_params, action)
    if action == 'update' || action == 'create'
      if account_params.key?(:business_type) == false
        return [false, 'params for :business_type does not exist']
      elsif account_params[:business_type] != 'individual'
        return [false, "invalid business type : #{account_params[:business_type]}"]
      elsif account_params.key?(:individual) == false
        return [false, 'params for :individual does not exist']
      end

      if action == 'create'
        if account_params.key?(:type) == false
          return [false, 'params for :type does not exist']
        elsif account_params[:type] != 'custom'
          return [false, "invalid connected account type : #{account_params[:type]}"]
        elsif account_params.key?(:country) == false
          return [false, 'params for :country does not exist']
        elsif account_params[:country] != 'JP'
          return [false, "invalid country : #{account_params[:country]}"]
        elsif account_params[:individual].key?(:email) == false
          return [false, 'params for :email does not exist']
        elsif account_params[:individual][:email].nil?
          return [false, 'params for :email is blank']
        end
      end
    else
      return [false, "invalid action : #{action}"]
    end
    [true, nil]
  end

  def hankaku(str)
    if str.nil?
      nil
    else
      NKF.nkf('-w -Z4', str)
    end
  end

  def self.parse_account_info(stripe_account_obj)
    check_results = Account.check_stripe_results(stripe_account_obj)
    return [false, check_results[1]] if check_results[0] == false

    personal_info = StripeAccountForm.parse_personal_info(stripe_account_obj['individual'])
    return [false, personal_info[1]] if personal_info[0] == false

    id = stripe_account_obj['id']

    tos_acceptance = if stripe_account_obj.key?('tos_acceptance')
                       stripe_account_obj['tos_acceptance']
                     else
                       { 'date' => nil, 'ip' => nil }
                     end

    payouts_enabled = (stripe_account_obj['payouts_enabled'] if stripe_account_obj.key?('payouts_enabled'))

    requirements = (stripe_account_obj['requirements'] if stripe_account_obj.key?('requirements'))

    bank_info = Externalaccount.parse_bank_info(stripe_account_obj)
    if bank_info[0] == false
      bank_info[1] = { 'bank_name' => nil, 'branch_name' => nil, 'account_number' => nil, 'account_holder_name' => nil }
    end

    account_info = {
      'id' => id,
      'personal_info' => personal_info[1],
      'tos_acceptance' => tos_acceptance,
      'bank_info' => bank_info[1],
      'payouts_enabled' => payouts_enabled,
      'requirements' => requirements
    }

    [true, account_info]
  end

  def self.check_stripe_results(stripe_obj)
    return [false, 'params for :object does not exist'] if stripe_obj.key?('object') == false

    case stripe_obj['object']
    when 'account'
      if stripe_obj.key?('id') == false
        [false, 'stripe id does not exist']
      elsif stripe_obj.key?('individual') == false
        [false, 'params for :individual does not exist']
      else
        [true, nil]
      end
    when 'balance' then
      return [false, 'params for :available does not exist'] if stripe_obj.key?('available') == false
      return [false, 'params for :pending does not exist'] if stripe_obj.key?('pending') == false

      # if stripe_account_hash["livemode"] == false
      #   return [false, "livemode is set to false"]
      # end
      [true, nil]
    else
      [false, 'unknown stripe object type']
    end
  end
end
