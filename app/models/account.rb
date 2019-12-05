class Account < ApplicationRecord
  belongs_to  :user
  has_one     :externalaccount, dependent: :destroy
  has_many    :idcards, dependent: :destroy
  has_many    :payouts, dependent: :destroy
  validates   :user_id, presence: true, uniqueness: true
  validates   :stripe_acct_id, uniqueness: { case_sensitive: true }, allow_nil: true
  validate    :stripe_acct_id_check
  include StripeUtils

  # custom validation
  def stripe_acct_id_check
    if self.stripe_acct_id.present?
      unless self.stripe_acct_id.starts_with? 'acct_'
        errors.add(:stripe_acct_id, "stripe_acct_id does not start with acct_")
      end
    end
  end
  
  def get_stripe_account
    if self.stripe_acct_id
      begin
        stripe_account_obj = JSON.parse(Stripe::Account.retrieve(self.stripe_acct_id).to_s)
      rescue => e
        ErrorUtility.log_and_notify e
        return [false, "Stripe error - #{e.message}"]
      end
      account_info = Account.parse_account_info(stripe_account_obj)
      if account_info[0]
        return [true, account_info[1]]
      else
        return [false, "error in parse_account_info : #{account_info[1]}"]
      end
    else
      return [false, "stripe_acct_id is blank"]
    end
  end

  def self.create_stripe_account(account_params)
    inputs_check = Account.check_stripe_inputs(account_params, "create")
    if inputs_check[0]
      begin
        stripe_account_obj = JSON.parse(Stripe::Account.create(account_params).to_s)
      rescue => e
        ErrorUtility.log_and_notify e
        return [false, "Stripe error - #{e.message}"]
      end
      account_info = Account.parse_account_info(stripe_account_obj)
      if account_info[0] == true
        return [true, account_info[1]]
      else
        return [false, account_info[1]]
      end
    else
      return [false, inputs_check[1]]
    end
  end
  
  def update_stripe_account(account_params)
    if self.stripe_acct_id
      inputs_check = Account.check_stripe_inputs(account_params, "update")
      if inputs_check[0]
        begin
          stripe_account_obj = JSON.parse(Stripe::Account.update(self.stripe_acct_id, account_params).to_s)
        rescue => e
          ErrorUtility.log_and_notify e
          return [false, "Stripe error - #{e.message}"]
        end
        account_info = Account.parse_account_info(stripe_account_obj)
        if account_info[0]
          return [true, account_info[1]]
        else
          return [false, account_info[1]]
        end
      else
        return [false, inputs_check[1]]
      end
    else
      return [false, "stripe_acct_id is blank"]
    end
  end
  
  def delete_stripe_account
    if self.stripe_acct_id
      if self.zero_balance
        begin
          deleted_stripe_account = JSON.parse(Stripe::Account.delete(self.stripe_acct_id).to_s)
        rescue => e
          ErrorUtility.log_and_notify e
          return [false, "Stripe error - #{e.message}"]
        end
        if deleted_stripe_account["deleted"]
          return [true, {"account" => deleted_stripe_account}]
        else
          return [false, "account was not deleted for some reason"]
        end
      else
        return [false, "balance still remains on the account"]
      end
    else
      return [false, "stripe_acct_id is blank"]
    end
  end

  def get_stripe_balance
    if self.stripe_acct_id
      begin
        stripe_balance_obj = JSON.parse(Stripe::Balance.retrieve({stripe_account: self.stripe_acct_id}).to_s)
      rescue => e
        ErrorUtility.log_and_notify e
        return [false, "Stripe error - #{e.message}"]
      end
      check_results = Account.check_stripe_results(stripe_balance_obj)
      if check_results[0]
        return [true, stripe_balance_obj]
      else
        return [false, check_results[1]]
      end
    else
      return [false, "stripe_acct_id is blank"]
    end
  end

  def zero_balance
    balance_res = self.get_stripe_balance

    if balance_res[0]
      balance_hash = balance_res[1]
      
      if balance_hash["available"][0]["amount"].present?
        available_bal = balance_hash["available"][0]["amount"]
      else
        available_bal = 0
      end
      
      if balance_hash["pending"][0]["amount"].present?
        pending_bal = balance_hash["pending"][0]["amount"]
      else
        pending_bal = 0
      end
      
      if available_bal == 0 && pending_bal == 0
        return true
      else
        return false
      end
    else
      return false
    end
  end

  
  private
  
  def self.parse_account_info(stripe_account_obj)
    
    check_results = Account.check_stripe_results(stripe_account_obj)
    if check_results[0] == false
      return [false, check_results[1]]
    end
    personal_info = Account.parse_personal_info(stripe_account_obj["individual"])
    if personal_info[0] == false
      return [false, personal_info[1]]
    end
      
    id = stripe_account_obj["id"]
    
    if stripe_account_obj.key?("tos_acceptance")
      tos_acceptance = stripe_account_obj["tos_acceptance"]
    else
      tos_acceptance = {"date" => nil, "ip" => nil}
    end
    
    if stripe_account_obj.key?("payouts_enabled")
      payouts_enabled = stripe_account_obj["payouts_enabled"]
    else
      payouts_enabled = nil
    end
    
    if stripe_account_obj.key?("requirements")
      requirements = stripe_account_obj["requirements"]
    else
      requirements = nil
    end
    
    bank_info = Externalaccount.parse_bank_info(stripe_account_obj)
    if bank_info[0] == false
      bank_info[1] = {"bank_name"=>nil, "branch_name"=>nil, "account_number"=>nil, "account_holder_name"=>nil}
    end
    
    account_info = {
      "id" => id,
      "personal_info" => personal_info[1],
      "tos_acceptance" => tos_acceptance,
      "bank_info" => bank_info[1],
      "payouts_enabled" => payouts_enabled,
      "requirements" => requirements
    }

    return [true, account_info]
    
  end

  def self.parse_personal_info(individual)
    
    if individual.key?("last_name_kanji")
      last_name_kanji = individual["last_name_kanji"]
    else
      last_name_kanji = nil
    end
    
    if individual.key?("last_name_kana")
      last_name_kana = individual["last_name_kana"]
    else
      last_name_kana = nil
    end
    
    if individual.key?("first_name_kanji")
      first_name_kanji = individual["first_name_kanji"]
    else
      first_name_kanji = nil
    end
    
    if individual.key?("first_name_kana")
      first_name_kana = individual["first_name_kana"]
    else
      first_name_kana = nil
    end
    
    if individual.key?("gender")
      case individual["gender"]
      when "male" then 
        gender = "男性"
      when "female" then
        gender = "女性"
      else
        gender = nil
      end
    else
      gender = nil
    end
    
    if individual.key?("email")
      email = individual["email"]
    else
      email = nil
    end
    
    if individual.key?("dob")
      if individual["dob"]["year"].present?
        year = individual["dob"]["year"]
      else
        year = nil
      end
      if individual["dob"]["month"].present?
        month = individual["dob"]["month"]
      else
        month = nil
      end
      if individual["dob"]["day"].present?
        day = individual["dob"]["day"]
      else
        day = nil
      end
    else
      year = nil
      month = nil
      day = nil
    end
    
    personal_info = {}
    personal_info.merge!({"last_name_kanji" => last_name_kanji})
    personal_info.merge!({"last_name_kana" => last_name_kana})
    personal_info.merge!({"first_name_kanji" => first_name_kanji})
    personal_info.merge!({"first_name_kana" => first_name_kana})
    personal_info.merge!({"gender" => gender})
    personal_info.merge!({"email" => email})
    personal_info.merge!({"dob" => {"year" => year, "month" => month, "day" => day}})
    if individual.key?("address_kanji")
      personal_info.merge!({"postal_code" => hankaku(individual["address_kanji"]["postal_code"])})
      personal_info.merge!({"kanji_state" => individual["address_kanji"]["state"]})
      personal_info.merge!({"kanji_city"  => individual["address_kanji"]["city"]})
      personal_info.merge!({"kanji_town"  => individual["address_kanji"]["town"]})
      personal_info.merge!({"kanji_line1" => individual["address_kanji"]["line1"]})
      personal_info.merge!({"kanji_line2" => individual["address_kanji"]["line2"]})
    end
    if individual.key?("address_kana")
      personal_info.merge!({"kana_state" => individual["address_kana"]["state"]})
      personal_info.merge!({"kana_city" => individual["address_kana"]["city"]})
      personal_info.merge!({"kana_town" => individual["address_kana"]["town"]})
      personal_info.merge!({"kana_line1" => Account.hankaku(individual["address_kana"]["line1"])})
      personal_info.merge!({"kana_line2" => Account.hankaku(individual["address_kana"]["line2"])})
      # puts "HANKAKU test = "
      # puts personal_info["kana_line2"]
    end
    if individual.key?("phone")
      personal_info.merge!({"phone" => individual["phone"]})
    end
    if individual.key?("verification")
      personal_info.merge!({"verification" => individual["verification"]})
    end

    return [true, personal_info]
  end
  
  def self.check_stripe_inputs(account_params, action)

    if action == "update" || action == "create"
      if account_params.key?(:business_type) == false
        return [false, "params for :business_type does not exist"]
      elsif account_params[:business_type] != "individual"
        return [false, "invalid business type : #{account_params[:business_type]}"]
      elsif account_params.key?(:individual) == false
        return [false, "params for :individual does not exist"]
      end
      if action == "create"
        if account_params.key?(:type) == false
          return [false, "params for :type does not exist"]
        elsif account_params[:type] != "custom"
          return [false, "invalid connected account type : #{account_params[:type]}"]
        elsif account_params.key?(:country) == false
          return [false, "params for :country does not exist"]
        elsif account_params[:country] != "JP"
          return [false, "invalid country : #{account_params[:country]}"]
        elsif account_params[:individual].key?(:email) == false
          return [false, "params for :email does not exist"]
        elsif account_params[:individual][:email] == nil
          return [false, "params for :email is blank"]
        end
      end
    else
      return [false, "invalid input : action is #{action}"]
    end
    
    return [true, nil]
  end
  
  def self.check_stripe_results(stripe_obj)
    
    if stripe_obj.key?("object") == false
      return [false, "params for :object does not exist"]
    end

    case stripe_obj["object"]
      when "account" then
        if stripe_obj.key?("id") == false
          return [false, "stripe id does not exist"]
        elsif stripe_obj.key?("individual") == false
          return [false, "params for :individual does not exist"]
        else
          return [true, nil]
        end
      when "balance" then
        if stripe_obj.key?("available") == false
          return [false, "params for :available does not exist"]
        end
        if stripe_obj.key?("pending") == false
          return [false, "params for :pending does not exist"]
        end
        # if stripe_account_hash["livemode"] == false
        #   return [false, "livemode is set to false"]
        # end
        return [true, nil]
      else
        return [false, "unknown stripe object type"]
    end
  end

  def self.hankaku(str)
    if str == nil
      return nil
    else
      return NKF.nkf('-w -Z4', str)
    end
  end
end
