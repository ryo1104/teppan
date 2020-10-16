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

  def get_stripe_account
    if acct_id
      begin
        stripe_account_obj = JSON.parse(Stripe::Account.retrieve(acct_id).to_s)
      rescue StandardError => e
        ErrorUtility.log_and_notify e
        return [false, "Stripe error - #{e.message}"]
      end
      account_info = StripeAccount.parse_account_info(stripe_account_obj)
      if account_info[0]
        [true, account_info[1]]
      else
        [false, "error in parse_account_info : #{account_info[1]}"]
      end
    else
      [false, 'acct_id is blank']
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
      account_info = StripeAccount.parse_account_info(stripe_account_obj)
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
    if acct_id
      stripe_inputs = stripe_inputs_update(account_form, remote_ip)
      inputs_check = check_stripe_inputs(stripe_inputs, 'update')
      if inputs_check[0]
        begin
          stripe_account_obj = JSON.parse(Stripe::Account.update(acct_id, stripe_inputs).to_s)
        rescue => e
          ErrorUtility.log_and_notify e
          return [false, "Stripe error - #{e.message}"]
        end
        account_info = StripeAccount.parse_account_info(stripe_account_obj)
        if account_info[0]
          [true, account_info[1]]
        else
          [false, account_info[1]]
        end
      else
        [false, inputs_check[1]]
      end
    else
      [false, 'acct_id is blank']
    end
  end

  def delete_stripe_account
    if acct_id
      if zero_balance
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
      else
        [false, 'balance still remains on the account']
      end
    else
      [false, 'acct_id is blank']
    end
  end

  def get_stripe_balance
    if acct_id
      begin
        stripe_balance_obj = JSON.parse(Stripe::Balance.retrieve({ stripe_account: acct_id }).to_s)
      rescue StandardError => e
        ErrorUtility.log_and_notify e
        return [false, "Stripe error - #{e.message}"]
      end
      check_results = StripeAccount.check_stripe_results(stripe_balance_obj)
      if check_results[0]
        [true, stripe_balance_obj]
      else
        [false, check_results[1]]
      end
    else
      [false, 'acct_id is blank']
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
  
  def get_stripe_ext_account
    if acct_id.present?
      begin
        stripe_account_obj = JSON.parse(Stripe::Account.retrieve(acct_id).to_s)
      rescue StandardError => e
        return [false, "Stripe error - #{e.message}"]
      end
      bank_info = StripeAccount.parse_bank_info(stripe_account_obj)
      if bank_info[0]
        [true, bank_info[1]]
      else
        [false, "error in parse_bank_info : #{bank_info[1]}"]
      end
    else
      [false, 'acct_id is blank']
    end
  end
  
  def create_stripe_ext_account(stripe_bank_inputs)
    if stripe_bank_inputs.present?
      if acct_id.present?
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
      else
        [false, 'acct_id is blank']
      end
    else
      [false, 'stripe_bank_inputs is blank']
    end
  end

  def delete_stripe_ext_account(old_stripe_bank_id)
    if acct_id.present?
      if ext_acct_id.present?
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
      else
        [false, 'ext_acct_id is blank']
      end
    else
      [false, 'acct_id is blank']
    end
  end

  def self.parse_bank_info(stripe_account_obj)
    if stripe_account_obj.present?
      if stripe_account_obj.key?('external_accounts')
        if stripe_account_obj['external_accounts']['data'].empty?
          [false, 'external account data is blank']
        else
          stripe_account_obj['external_accounts']['data'].map do |ext_acct|
            if ext_acct.key?('routing_number')
              if ext_acct['routing_number'].present?
                if ext_acct['routing_number'].length == 7
                  bank_code = ext_acct['routing_number'][0, 4]
                  branch_code = ext_acct['routing_number'][4, 3]
                  bank = Bank.find_by(code: bank_code)
                  if bank.present?
                    branch = bank.branches.find_by(code: branch_code)
                    if branch.present?
                      if ext_acct.key?('last4')
                        if ext_acct.key?('account_holder_name')
                          info = {}
                          info.merge!('bank_name' => bank.name)
                          info.merge!('branch_name' => branch.name)
                          info.merge!('account_number' => '***' + ext_acct['last4'])
                          info.merge!('account_holder_name' => ext_acct['account_holder_name'])
                          return [true, info]
                        else
                          return [false, 'account_holder_name does not exist']
                        end
                      else
                        return [false, 'last4 does not exist']
                      end
                    else
                      return [false, 'unable to retrieve branch from database']
                    end
                  else
                    return [false, 'unable to retrieve bank from database']
                  end
                else
                  return [false, 'routing number is not 7 digits']
                end
              else
                return [false, 'routing number does not exist']
              end
            else
              return [false, 'routing number hash does not exist']
            end
          end
        end
      else
        [false, 'external account information does not exist in stripe account obj']
      end
    else
      [false, 'stripe_account_obj does not exist']
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
  
  def find_idcards
    cards = stripe_idcards
    frontcard = cards.find_by(frontback: "front")
    backcard = cards.find_by(frontback: "back")
    [frontcard, backcard]
  end

  def hankaku(str)
    if str.nil?
      nil
    else
      NKF.nkf('-w -Z4', str)
    end
  end

  def self.parse_account_info(stripe_account_obj)
    check_results = StripeAccount.check_stripe_results(stripe_account_obj)
    return [false, check_results[1]] if check_results[0] == false

    personal_info = StripeAccountForm.parse_personal_info(stripe_account_obj['individual'])
    return [false, personal_info[1]] if personal_info[0] == false

    id = stripe_account_obj['id']

    if stripe_account_obj.key?('tos_acceptance')
       tos_acceptance = stripe_account_obj['tos_acceptance']
    else
       tos_acceptance = { 'date' => nil, 'ip' => nil }
    end

    payouts_enabled = (stripe_account_obj['payouts_enabled'] if stripe_account_obj.key?('payouts_enabled'))
    requirements = (stripe_account_obj['requirements'] if stripe_account_obj.key?('requirements'))

    bank_info = StripeAccount.parse_bank_info(stripe_account_obj)
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
