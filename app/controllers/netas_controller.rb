class NetasController < ApplicationController
  before_action :authenticate_user!, except: %i[index hashtags]

  def index
    begin
      @search = Neta.includes({user: [image_attachment: :blob]}, :hashtags).where(private_flag: false).ransack(params[:q])
      @netas = @search.result(distinct: true).order("created_at DESC").page(params[:page]).per(20)
      @hashtag_ranking = Hashtag.get_ranking(10)
      @neta_ranking = Ranking.includes(:rankable).where(rankable_type: "Neta")
      @view_history = Pageview.get_history("Neta", current_user.id, 30, 5) if user_signed_in?
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to root_path, alert: "エラーが発生しました。" and return
    end
  end
  
  def new
    begin
      @topic = Topic.find(params[:topic_id])
      @neta = @topic.netas.new
      @alltags_for_chips = Hashtag.for_chips_autocomplete(Hashtag.all)
      @mytags_for_chips = Hashtag.for_chips_initial(nil)
      @qualified = current_user.premium_qualified
      @stale_form_check_timestamp = Time.zone.now.to_i
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to topic_path(params[:topic_id]), alert: "エラーが発生しました。" and return
    end 
  end
  
  def create
    begin
      if session[:last_created_at].to_i > session_params[:timestamp].to_i
        redirect_to topic_path(params[:topic_id]), alert: "入力内容はすでに保存されています。" and return
      else
        @topic = Topic.find(params[:topic_id])
        @neta = @topic.netas.create!(create_params)
        #@copy_check_obj = Copycheck.create(neta_id: @neta.id, text: @neta.text+" "+@neta.valuetext)
        @neta.add_hashtags(tag_params)
        @stale_form_check_timestamp = Time.zone.now.to_i
        session[:last_created_at] = @stale_form_check_timestamp
        redirect_to topic_path(params[:topic_id]), notice: "ネタを投稿しました。"
      end
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to new_topic_neta_path(params[:topic_id]), alert: "エラーが発生しました。" and return
    end
  end

  def show
    begin
      @neta = Neta.find(params[:id])
      @owner = @neta.owner(current_user)
      if @owner || @neta.private_flag == false
        @reviews = @neta.reviews.includes({user: [image_attachment: :blob]})
        @myreview = @reviews.where(user_id: current_user.id)
        @newreview = Review.new unless @myreview.present?
        @for_sale = @neta.for_sale if @neta.price != 0
        unless @owner
          @purchased = @neta.trades.find_by(buyer_id: current_user.id)
          @neta.add_pageview(current_user)
        end
      else
        @message = "このネタは投稿者が非公開に設定しています。"
      end
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to topics_path, alert: "エラーが発生しました。" and return
    end
  end
  
  def edit
    begin
      @neta = Neta.find(params[:id])
      unless @neta.owner(current_user)
        redirect_to neta_path(params[:id]), alert: "権限がありません。" and return
      end
      @editable = @neta.editable
      @qualified = current_user.premium_qualified
      @alltags_for_chips = Hashtag.for_chips_autocomplete(Hashtag.all)
      @mytags_for_chips = Hashtag.for_chips_initial(@neta.hashtags)
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to neta_path(params[:id]), alert: "エラーが発生しました。" and return
    end
  end
  
  def update
    begin
      @neta = Neta.find(params[:id])
      @neta.update!(update_params)
      @neta.add_hashtags(tag_params)
      # copy_check_obj = Copycheck.create(neta_id: neta.id, text: neta.text)
      # ccd_post_result = copy_check_obj.post_ccd_check(neta.text)
      # copy_check_obj.update(queue_id: ccd_post_result["queue_id"]) 
      redirect_to neta_path(params[:id]), notice: "ネタを更新しました。" and return
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to neta_path(params[:id]), alert: "エラーが発生しました。" and return
    end
  end
  
  def destroy
    begin
      @neta = Neta.includes(:trades, :interests, :reviews, :pageviews, :rankings).find(params[:id])
      if @neta.owner(current_user)
        if @neta.has_dependents
          redirect_to neta_path(params[:id]), alert: "このネタに属する取引等があるため、削除できません。" and return
        else
          topic_id = @neta.topic_id
          @neta.destroy!
          redirect_to topic_path(topic_id), notice: "ネタを削除しました。" and return
        end
      else
        redirect_to neta_path(params[:id]), alert: "削除する権限がありません。" and return
      end
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to neta_path(params[:id]), alert: "エラーが発生しました。" and return
    end
  end

  def hashtags
    begin
      if params[:hashname] == "search" && params[:search_form] == "true"
        hashname = params[:searchname]
      else
        hashname = params[:hashname]
      end
      @tag = Hashtag.find_by(hashname: hashname)
      @tag.add_hit(current_user) if user_signed_in?
      @netas = @tag.netas.includes(:hashtag_netas, :hashtags, {user: [image_attachment: :blob]})
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to topics_path, alert: "エラーが発生しました。" and return
    end
  end

  private

  def create_params
    params.require(:neta).permit(:title, :content, :valuetext, :price, :private_flag).merge(user_id: current_user.id)
  end
  
  def update_params
    params.require(:neta).permit(:title, :content, :valuetext, :price, :private_flag)
  end
  
  def tag_params
    tag_p = params.permit(tag_list: [])
    tag_list = tag_p[:tag_list]
  end
  
  def session_params
    params.require(:neta).permit(:timestamp)
  end
  
  def check_login
    redirect_to action: :show unless user_signed_in?
  end

end
