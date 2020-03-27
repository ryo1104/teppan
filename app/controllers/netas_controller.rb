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
        redirect_to topic_path(params[:topic_id]), alert: "すでに投稿済です。" and return
      else
        @topic = Topic.find(params[:topic_id])
        @neta = @topic.netas.new(create_params)
        if @neta.valid? && @neta.check_hashtags(tag_array)
          Neta.transaction do
            @neta.save!
            @neta.add_hashtags(tag_array)
          end
          #@copy_check_obj = Copycheck.create(neta_id: @neta.id, text: @neta.text+" "+@neta.valuetext)
          session[:last_created_at] = Time.zone.now.to_i
          redirect_to neta_path(@neta.id), notice: "ネタを投稿しました。"
        else
          @stale_form_check_timestamp = Time.zone.now.to_i
          render :new and return
        end
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
        # @for_sale = true
        unless @owner
          @purchased = @neta.trades.find_by(buyer_id: current_user.id)
          # @purchased = Trade.new
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
      @current_tags = @neta.get_hashtags_str
      @stale_form_check_timestamp = Time.zone.now.to_i
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to neta_path(params[:id]), alert: "エラーが発生しました。" and return
    end
  end
  
  def update
    begin
      if session[:last_created_at].to_i > session_params[:timestamp].to_i
        redirect_to neta_path(params[:id]), alert: "投稿はすでに更新されています。" and return
      else
        @neta = Neta.find(params[:id])
        @neta.assign_attributes(update_params)
        if @neta.valid? && @neta.check_hashtags(tag_array)
          Neta.transaction do
            @neta.save!
            @neta.add_hashtags(tag_array)
          end
          # copy_check_obj = Copycheck.create(neta_id: neta.id, text: neta.text)
          # ccd_post_result = copy_check_obj.post_ccd_check(neta.text)
          # copy_check_obj.update(queue_id: ccd_post_result["queue_id"]) 
          session[:last_created_at] = Time.zone.now.to_i
          redirect_to neta_path(params[:id]), notice: "ネタを更新しました。" and return
        else
          @stale_form_check_timestamp = Time.zone.now.to_i
          @current_tags = @neta.get_hashtags_str
          render :edit and return
        end
      end
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to neta_path(params[:id]), alert: "エラーが発生しました。" and return
    end
  end
  
  def destroy
    begin
      @neta = Neta.includes(:trades, :interests, :reviews, :pageviews, :rankings, :hashtag_netas).find(params[:id])
      if @neta.owner(current_user)
        if @neta.has_dependents
          redirect_to neta_path(params[:id]), alert: "このネタに属する取引等があるため、削除できません。" and return
        else
          topic_id = @neta.topic_id
          @neta.delete_hashtags
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
        hashname = params[:keyword]
      else
        hashname = params[:hashname]
      end
      
      if @tag = Hashtag.find_by(hashname: hashname)
        @tag.add_hit(current_user) if user_signed_in?
        @netas = @tag.netas.includes(:hashtag_netas, :hashtags, {user: [image_attachment: :blob]})
      else
        @tag = Hashtag.new(hashname: hashname)
        @netas = nil
      end
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to topics_path, alert: "エラーが発生しました。" and return
    end
  end
  
  def tag_search_autocomplete
    items = Hashtag.ransack(hashname_or_hiragana_cont: params[:keyword]).result.order("neta_count DESC").limit(10)
    render json: HashtagSerializer.new(items)
  end

  private

  def create_params
    params.require(:neta).permit(:title, :content, :valuecontent, :price, :private_flag).merge(user_id: current_user.id)
  end
  
  def update_params
    params.require(:neta).permit(:title, :content, :valuecontent, :price, :private_flag)
  end
  
  def tag_params
    params.require(:neta).permit(:tags)
  end
  
  def tag_array
    if tag_params["tags"].present?
      tag_str = tag_params["tags"]
      return tag_str.split(/,/)
    else
      return []
    end
  end
  
  def session_params
    params.require(:neta).permit(:timestamp)
  end
  
  def check_login
    redirect_to action: :show unless user_signed_in?
  end

end
