class Externalaccount < ApplicationRecord
  belongs_to  :account
  validates   :account_id, presence: true, uniqueness: true
  include StripeUtils
  
  def get_stripe_ext_account
    stripe_acct_id = self.account.stripe_acct_id
    if stripe_acct_id
      begin
        stripe_account_obj = JSON.parse(Stripe::Account.retrieve(stripe_acct_id).to_s)
      rescue => e
        return [false, "Stripe error - #{e.message}"]
      end
      bank_info = Externalaccount.parse_bank_info(stripe_account_obj)
      if bank_info[0]
        return [true, bank_info[1]]
      else
        return [false, "error in parse_bank_info : #{bank_info[1]}"]
      end
    else
      return [false, "stripe_acct_id is blank"]
    end
  end
  
  def create_stripe_ext_account(stripe_bank_inputs)
    if stripe_bank_inputs.present?
      stripe_acct_id = self.account.stripe_acct_id
      if stripe_acct_id
        begin
          res = JSON.parse(Stripe::Account.create_external_account(stripe_acct_id, stripe_bank_inputs).to_s)
          if res.key?("id")
            return [true, res]
          else
            return [false, "Failed to create external account"]
          end
        rescue => e
          return [false, "Stripe create_external_account error - #{e.message}"]
        end
      else
        return [false, "stripe_acct_id is blank"]
      end
    else
      return [false, "bank_params is blank"]
    end
  end
  
  def delete_stripe_ext_account(stripe_bank_id)
    if stripe_bank_id.present?
      stripe_acct_id = self.account.stripe_acct_id
      if stripe_acct_id
        begin
          res = JSON.parse(Stripe::Account.delete_external_account(stripe_acct_id, stripe_bank_id).to_s)
          if res.key?("deleted") && res["deleted"] == true
            return [true, res]
          else
            return [false, "Failed to delete external account"]
          end
        rescue => e
          return [false, "Stripe error - #{e.message}"]
        end
      else
        return [false, "stripe_acct_id is blank"]
      end
    else
      return [false, "stripe_bank_id is blank"]
    end
  end
  
  def self.parse_bank_info(stripe_account_obj)
    if stripe_account_obj.present?
      if stripe_account_obj.key?("external_accounts")
        unless stripe_account_obj["external_accounts"]["data"].empty?
          stripe_account_obj["external_accounts"]["data"].map do |ext_acct|
            if ext_acct.key?("routing_number")
              if ext_acct["routing_number"].present?
                if ext_acct["routing_number"].length == 7
                  bank_code = ext_acct["routing_number"][0 , 4]
                  branch_code = ext_acct["routing_number"][4 , 3]
                  bank = Bank.find_by(code: bank_code)
                  if bank.present?
                    branch = bank.branches.find_by(code: branch_code)
                    if branch.present?
                      if ext_acct.key?("last4")
                        if ext_acct.key?("account_holder_name")
                          info = {}
                          info.merge!("bank_name" => bank.name)
                          info.merge!("branch_name" => branch.name)
                          info.merge!("account_number" => "***"+ext_acct["last4"])
                          info.merge!("account_holder_name" => ext_acct["account_holder_name"])
                          return [true, info]
                        else
                          return [false, "account_holder_name does not exist"]
                        end
                      else
                        return [false, "last4 does not exist"]
                      end
                    else
                      return [false, "unable to retrieve branch from database"]
                    end
                  else
                    return [false, "unable to retrieve bank from database"]
                  end
                else
                  return [false, "routing number is not 7 digits"]
                end
              else
                return [false, "routing number does not exist"]
              end
            else
              return [false, "routing number hash does not exist"]
            end
          end
        else
          return [false, "external account data is blank"]
        end
      else
        return [false, "external account information does not exist in stripe account obj"]
      end
    else
      return [false, "stripe_account_obj does not exist"]
    end
  end
  
end
