class TradesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_tradeable

  def new
    begin
      @buyer = current_user
      @cards = @buyer.get_cards
      buyer_balance = @buyer.get_balance
      if buyer_balance[0]
        @balance = buyer_balance[1]
      else
        @balance = 0 #エラーハンドリングが必要
      end
      @price = @tradeable.price
      @ctax = Trade.get_ctax(@price)
      @charge_amount = @price + @ctax
      @stale_form_check_timestamp = Time.zone.now.to_i
      @destination = @tradeable.user.account.stripe_acct_id
      @success_url = neta_trades_url(@tradeable.id)
      @cancel_url = request.url
      @stripe_session = Trade.get_stripe_session(@tradeable, @destination, @success_url, @cancel_url )
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to "/#{@resource}/#{@id}", alert: e.message and return
    end
  end
  
  def create
    begin
      if session[:last_created_at].to_i > session_params[:timestamp].to_i
        redirect_to "/#{@resource}/#{@id}", alert: "すでに決済されています。" and return
      else
        # 取引情報を取得
        buyer = current_user
        seller = User.find(@tradeable.user_id)
        @trade_inputs = get_trade_inputs(buyer, seller, charge_params)
        unless @trade_inputs[0]
          redirect_to "/#{@resource}/#{@id}/trades/new", alert: @trade_inputs[1] and return
        end

        # 引き落とし元を取得
        @stripe_source = buyer.set_source(charge_params.merge!({"charge_amount" => @trade_inputs[1]["charge_amount"]}))
        if @stripe_source[0]
          buyer.reload
        else
          redirect_to "/#{@resource}/#{@id}/trades/new", alert: "支払い元の情報が取得できませんでした。" and return
        end
        
        # 決済処理
        @result_hash = Trade.charge(@stripe_source[1], buyer, seller, @tradeable, @trade_inputs[1]["charge_amount"], @trade_inputs[1]["seller_revenue"])
        
        # 取引・決済内容を記録
        if @result_hash["charge_result"]["id"].present?
          @tradeable.trades.create!(buyer_id: buyer.id, seller_id: seller.id, price: @trade_inputs[1]["price"], stripe_charge_id: @result_hash["charge_result"]["id"], tradetype: "TRADE", tradestatus: "DONE")
          @message = "#{seller.nickname}さんからネタを購入しました。"
          @stale_form_check_timestamp = Time.zone.now.to_i
          session[:last_created_at] = @stale_form_check_timestamp
        else
          redirect_to "/#{@resource}/#{@id}/trades/new", alert: "決済できませんでした。" and return
        end
      end
      
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to "/#{@resource}/#{@id}/trades/new", alert: e.message and return
    end
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
  
  def get_trade_inputs(buyer, seller, charge_params)

    if charge_params[:price].present?
      if charge_params[:price].to_i != 0
        price = charge_params[:price].to_i
      else
        return [false, "有料ネタではありません。"]
      end
    else
      return [false, "価格が入力されていません。"]
    end
    
    if seller.premium_user
      unless seller.account.stripe_acct_id.present?
        return [false, "売り手の販売アカウント情報が取得できませんでした。"]
      end
    else
      return [false, "認定ユーザーではありません。"]
    end

    ctax = Trade.get_ctax(price)
    unless ctax == 0
      charge_amount = price + ctax 
      seller_revenue = (0.9*(price)).floor
    else
      return [false, "消費税計算に問題が生じました。"]
    end
    
    if charge_params[:user_points].present?
      buyer_balance = buyer.get_balance
      if buyer_balance[0]
        if buyer_balance[1] >= charge_amount
          user_points = charge_params[:user_points]
        else
          return [false, "残高不足です。"]
        end
      else
        return [false, "残高の取得に失敗しました。"]
      end
    end
    
    trade_inputs = {}
    trade_inputs.merge!({"price" => price})
    trade_inputs.merge!({"ctax" => ctax})
    trade_inputs.merge!({"charge_amount" => charge_amount})
    trade_inputs.merge!({"user_points" => user_points})
    trade_inputs.merge!({"seller_revenue" => seller_revenue})
    
    return [true, trade_inputs]
  end

end
