class TradesController < ApplicationController
  include StripeUtils
  before_action :load_tradeable, except: %i[webhook done]
  skip_before_action :authenticate_user!, only: :webhook
  protect_from_forgery except: :webhook

  def new
    @buyer = current_user
    @cards = @buyer.get_cards
    buyer_balance = @buyer.get_balance
    @balance = buyer_balance[0] == true ? buyer_balance[1] : 0

    @price = @tradeable.price
    @ctax = Trade.get_ctax(@price)
    @charge_amount = @price + @ctax
    @seller = @tradeable.user
    @seller_revenue = Trade.get_seller_revenue(@price)

    @success_path = "http://ec2-52-221-192-110.ap-southeast-1.compute.amazonaws.com:8080/trades/done"
    @cancel_path = request.url
    @stripe_session = Trade.get_checkout_session(@tradeable, @buyer, @seller, @success_path, @cancel_path, @seller_revenue)

    @stale_form_check_timestamp = Time.zone.now.to_i
  end

  # def create
  # if session[:last_created_at].to_i > session_params[:timestamp].to_i
  #   redirect_to "/#{@resource}/#{@id}", alert: "すでに決済されています。" and return
  # else
  #   # 取引情報を取得
    # buyer = current_user
    # seller = User.find(@tradeable.user_id)
    # @trade_inputs = get_trade_inputs(buyer, seller, charge_params)
  #   unless @trade_inputs[0]
  #     redirect_to "/#{@resource}/#{@id}/trades/new", alert: @trade_inputs[1] and return
  #   end

  #   # 引き落とし元を取得
  #   @stripe_source = buyer.set_source(charge_params.merge!({"charge_amount" => @trade_inputs[1]["charge_amount"]}))
  #   if @stripe_source[0]
  #     buyer.reload
  #   else
  #     redirect_to "/#{@resource}/#{@id}/trades/new", alert: "支払い元の情報が取得できませんでした。" and return
  #   end

  #   # 決済処理
  #   @result_hash = Trade.charge(@stripe_source[1], buyer, seller, @tradeable, @trade_inputs[1]["charge_amount"], @trade_inputs[1]["seller_revenue"])

  #   # 取引・決済内容を記録
  #   if @result_hash["charge_result"]["id"].present?
  #     @tradeable.trades.create!(buyer_id: buyer.id, seller_id: seller.id, price: @trade_inputs[1]["price"], stripe_charge_id: @result_hash["charge_result"]["id"], tradetype: "TRADE", tradestatus: "DONE")
  #     @message = "#{seller.nickname}さんからネタを購入しました。"
  #     @stale_form_check_timestamp = Time.zone.now.to_i
  #     session[:last_created_at] = @stale_form_check_timestamp
  #   else
  #     redirect_to "/#{@resource}/#{@id}/trades/new", alert: "決済できませんでした。" and return
  #   end
  # end
  # end

  def webhook
    payload = request.body.read
    event = nil
    endpoint_secret = ENV['STRIPE_WEBHOOK_SECRET']
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']

    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError
      render status: 400  # Invalid payload
      return
    rescue Stripe::SignatureVerificationError
      render status: 400  # Invalid signature
      return
    end

    if event['type'] == 'checkout.session.completed'
      result = fulfill_order(event['data']['object'])
      unless result[0]
        Rails.logger.error "fulfill order failed. #{result[1]}"
        render status: 400
      end
    else
      Rails.logger.error "event type is not checkout.session.completed, but instead #{event['type']}."
      render status: 400
    end
  end
  
  def done
  end

  private

  def load_tradeable
    @resource, @id = request.path.split('/')[1, 2]
    @tradeable = @resource.singularize.classify.constantize.find(@id)
  end

  def charge_params
    params.permit(:stripeToken, :card_id, :user_points, :price)
  end

  def session_params
    params.permit(:timestamp)
  end
  
  def fulfill_order(checkout_session)
    pi_obj =  JSON.parse(Stripe::PaymentIntent.retrieve(checkout_session["payment_intent"]).to_s)
    return [false, "unable to retrieve payment intent"] unless pi_obj["id"].present?
    return [false, "unable to retrieve charges"] unless pi_obj["charges"]["data"][0].present?

    charge = pi_obj["charges"]["data"][0]
    seller_acct = StripeAccount.find_by(acct_id: charge["destination"])
    return [false, "Stripe account not found for #{charge["destination"]}"] unless seller_acct.present?
    seller = seller_acct.user
    
    if checkout_session["customer_email"].present?
      buyer = User.find_by(email: checkout_session["customer_email"])
      return [false, "User not found for email #{checkout_session["customer_email"]}"] unless buyer.present?
    elsif checkout_session["customer"].present?
      buyer = User.find_by(stripe_cus_id: checkout_session["customer"])
      return [false, "User not found for stripe_cus_id #{checkout_session["customer"]}"] unless buyer.present?
      buyer.update(stripe_cus_id: checkout_session["customer"])
    else
      return [false, "customer info is blank in checkout session"]
    end
    
    if checkout_session["metadata"]["neta_id"].present?
      neta_id = checkout_session["metadata"]["neta_id"]
    else
      return [false, "neta_id is blank in checkout session"]
    end

    trade = Trade.new(buyer_id: buyer.id, seller_id: seller.id, price: charge["amount"].to_i, 
                      stripe_ch_id: charge["id"], stripe_pi_id: pi_obj["id"],
                      tradeable_type: "Neta", tradeable_id: neta_id)
    if trade.save
      return [true, trade]
    else
      return [false, "Failed to save Trade. buyer_id : #{buyer.id}, seller_id : #{seller.id}, price : #{charge["amount"]}, stripe_ch_id : #{charge["id"]}, stripe_pi_id : #{pi_obj["id"]}, tradeable_type : Neta, tradeable_id : #{neta_id} "]
    end
  end

  # def get_trade_inputs(buyer, seller, charge_params)
  #   if charge_params[:price].present?
  #     if charge_params[:price].to_i != 0
  #       price = charge_params[:price].to_i
  #     else
  #       return [false, '有料ネタではありません。']
  #     end
  #   else
  #     return [false, '価格が入力されていません。']
  #   end

  #   if seller.premium_user
  #     return [false, '売り手の販売アカウント情報が取得できませんでした。'] unless seller.account.acct_id.present?
  #   else
  #     return [false, '認定ユーザーではありません。']
  #   end

  #   ctax = Trade.get_ctax(price)
  #   if ctax == 0
  #     return [false, '消費税計算に問題が生じました。']
  #   else
  #     charge_amount = price + ctax
  #     seller_revenue = (0.9 * price).floor
  #   end

  #   if charge_params[:user_points].present?
  #     buyer_balance = buyer.get_balance
  #     if buyer_balance[0]
  #       if buyer_balance[1] >= charge_amount
  #         user_points = charge_params[:user_points]
  #       else
  #         return [false, '残高不足です。']
  #       end
  #     else
  #       return [false, '残高の取得に失敗しました。']
  #     end
  #   end

  #   trade_inputs = {}
  #   trade_inputs.merge!({ 'price' => price })
  #   trade_inputs.merge!({ 'ctax' => ctax })
  #   trade_inputs.merge!({ 'charge_amount' => charge_amount })
  #   trade_inputs.merge!({ 'user_points' => user_points })
  #   trade_inputs.merge!({ 'seller_revenue' => seller_revenue })

  #   [true, trade_inputs]
  # end
end
