class RequestsController < ApplicationController
  before_action :authenticate_user!, except: :index
  
  def index
    @search = Request.includes(user: [image_attachment: :blob]).ransack(params[:q])
    @requests = @search.result.order("created_at DESC").page(params[:page]).per(10)
    if user_signed_in?
      @user_signed_id = true
    else
      @user_signed_id = false
    end
  end
  
  def new
    @request = Request.new
  end
  
  def create
    Request.create(create_params)
    redirect_to requests_path
  end
  
  def show
    @request = Request.find(params[:id])
    
    # 募集中、依頼済み、作業中、完了のいずれか
    @status = @request.get_status_string

    # requestor, assignee, third_partyのいずれか
    @i_am = @request.who_am_i(current_user)

    @comments = @request.comments.includes({user: [image_attachment: :blob]}).order("created_at ASC")
    @newcomment = Comment.new


    if @i_am == "requestor"
      @is_myrequest = true
    else
      @is_myrequest = false
    end
    
    # 募集中の場合
    if @request.status == "OPEN" 
      
      # Offer一覧
      @offer_posted = false
      @offers = @request.offers.includes(user: [image_attachment: :blob])
      @offers.each do |offer|
        if offer.user_id == current_user.id
          @offer_posted = true
        end
      end
      
      # 依頼者でなければ閲覧履歴を作成、お気に入り登録を取得
      unless @i_am == "requestor"
        @request.pageviews.create(user_id: current_user.id)
        @interest = Interest.find_by(user_id: current_user.id, interestable_type: "Request", interestable_id: @request.id)
      end
      
    # 依頼済み、作業中、完了の場合
    else 
      @assignee = @request.assignee
      @offer = @request.offers.find_by(user_id: @assignee.id)  
      
      # 依頼者またはライターのみ閲覧可能
      if @i_am == "requestor" || @i_am == "assignee"
        @viewable = true
      else
        @viewable = false
      end

      if @viewable == true #当事者の場合

        @neta = Neta.find_by(netaable_type: "Request", netaable_id: @request.id)
        
        # 完了であればレビューを取得、または書込みを促す
        if @request.status == "FINAL"
          @reviews = @neta.reviews
          unless @reviews.present?
            @newreview = Review.new
          end
        end
        
      else #当事者以外
        @not_viewable_message = "（当事者のみ閲覧可能の内容です）"
      end
    end
  end
  
  def edit
    @request = Request.find(params[:id])
  end
  
  def update

    thisrequest = Request.find(params[:id])

    # 受けたオファーに依頼をかける
    if thisrequest.status == "OPEN"
      if params.require(:request)[:status] == "ASSIGNED"
        update_result = thisrequest.assign(update_params)
      else
        thisrequest.update(update_params)
      end
    end
    
    # 依頼を受諾する
    if thisrequest.status == "ASSIGNED" && params.require(:request)[:status] == "IN_PROGRESS"
      update_result = thisrequest.accept(update_params)
    end

    # 納品完了
    if thisrequest.status == "IN_PROGRESS" && params.require(:request)[:status] == "FINAL"
      update_result = thisrequest.close(close_params)
    end
    
    if update_result[:status] == "0"
      redirect_to request_path
    else # エラーの場合
      @message = update_result[:message]
    end

  end
  
  def destroy
    request = Request.find(params[:id])
    request.delete
    redirect_to requests_path
  end
  
  private
  
  def create_params
    params.require(:request).permit(:title, :text, :price, :nextdate, :finaldate, :status).merge(user_id: current_user.id)
  end
  
  def update_params
    params.require(:request).permit(:title, :text, :price, :nextdate, :finaldate, :status, :assignee_id)
  end
  
  def close_params
    params.require(:request).permit(:price, :nextdate, :finaldate, :status)
  end
  
  def check_login
    redirect_to action: :index unless user_signed_in?
  end
  
  # def assign(req)
  #   offer = req.offers.find_by(user_id: params.require(:request)[:assignee_id])
  #   requestor = current_user
  #   if requestor.netcredit < offer.price
  #     @message = "ポイント残高不足です。"
  #   else
  #     req.transaction do
  #       req.update(update_params)
  #       requestor.debitcredit(offer.price, 0)
  #     end
  #     @message = "#{offer.user.nickname}さんに#{offer.price}ポイントで正式に依頼しました。依頼が承諾されるまでお待ちください。"
  #   end
  # end
  
  # def accept(req)
  #   req.update(update_params)
  #   @message = "依頼を引き受けました。"
  # end
  
  # def close(req)
  #   requestor = current_user
  #   assignee = User.find(req.assignee_id)
  #   if req.price - requestor.debit - requestor.credit > 0 
  #     @message = "ポイント残高不足です。"
  #   else
  #     close_params = params.require(:request).permit(:nextdate, :price, :status)
  #     req.transaction do
  #       req.update(close_params)
  #       requestor.debitcredit(-1*req.price, -1*req.price)
  #       assignee.debitcredit(0, req.price)
  #       Trade.create(tradeable_type: "Request", tradeable_id: req.id, buyer_id: requestor.id, seller_id: assignee.id, price: req.price, tradetype: "TRADE", tradestatus: "DONE")
  #     end
  #     @message = "#{assignee.nickname}さんに#{req.price}ポイントを支払い、依頼が完了しました。"
  #   end
  # end
end
