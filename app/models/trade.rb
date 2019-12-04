class Trade < ApplicationRecord
  include StripeUtils
  belongs_to :tradeable, polymorphic: true
  validates :buyer_id, presence: true, uniqueness: {:scope => [:seller_id, :tradeable_id, :tradeable_type], message: "重複した取引情報が存在しています。"  }
  validates :seller_id, presence: true
  validate  :stripe_charge_id_check
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10000 }

  # custom validation
  def stripe_charge_id_check
    if self.stripe_charge_id.present?
      unless self.stripe_charge_id.starts_with? 'ch_'
        errors.add(:stripe_charge_id, "invalid stripe_charge_id")
      end
    else
      errors.add(:stripe_charge_id, "blank stripe_charge_id")
    end
  end

  def self.get_ctax(amount)
    if amount.present?
      if amount.is_a?(Integer)
        return (amount*0.08).floor
      else
        raise ArgumentError, '入力値が整数ではありません。'
      end
    else
      raise ArgumentError, '入力値がありません。'
    end
  end

  def self.charge(source, buyer, seller, tradeable, charge_amount, seller_revenue)
    ret_hash = {}
    if source["object"] == "customer" || source["object"] == "card" #顧客に紐付いているカードで支払い
      begin
        charge = Stripe::Charge.create( { amount: charge_amount, 
                                          currency: 'jpy',
                                          customer: buyer.stripe_cus_id,
                                          destination: {
                                            amount: seller_revenue, #売り手へいくら配分するか
                                            account: seller.account.stripe_acct_id, #売り手アカウント
                                          },
                                        } )
      rescue => e
        body = e.json_body
        err  = body[:error]
        code = err[:code] if err[:code]
        message = err[:message] if err[:message]
        raise StandardError, "Stripe error : #{code}, #{message} "
      end
      charge_result = JSON.parse(charge.to_s)
      ret_hash.merge!({"charge_result" => charge_result})
        
    elsif source["object"] == "account" #Stripe残高で支払い
      #買い手のStripe残高から代金を徴収
      charge = Stripe::Charge.create({ amount: charge_amount, 
                                        currency: 'jpy',
                                        source: source["id"],
                                        customer: buyer.stripe_cus_id,
                                        transfer_group: "Product: #{tradeable.class.name}-#{tradeable.id}, BuyerID: #{buyer.id}",
                                      })
      #売り手に手数料を差し引いた金額を転送
      transfer = Stripe::Transfer.create({  amount: seller_revenue,
                                            currency: "jpy",
                                            destination: seller.account.stripe_acct_id,
                                            transfer_group: "Product: #{tradeable.class.name}-#{tradeable.id}, BuyerID: #{buyer.id}",
                                          })
    
      charge_result = JSON.parse(charge.to_s)
      ret_hash.merge!({"charge_result" => charge_result})
      
      transfer_result = JSON.parse(transfer.to_s)
      ret_hash.merge!({"transfer_result" => transfer_result})
    else
      raise StandardError, "不明な支払元情報です。"
    end
    return ret_hash
  end
  
end
