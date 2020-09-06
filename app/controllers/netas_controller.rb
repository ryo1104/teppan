class NetasController < ApplicationController

  def new
    @topic = Topic.find(params[:topic_id])
    @neta = @topic.netas.new
    @qualified = current_user.premium_qualified
    @stale_form_check_timestamp = Time.zone.now.to_i
  end

  def create
    if session[:last_created_at].to_i > session_params[:timestamp].to_i
      redirect_to topic_path(params[:topic_id]), alert: 'すでに投稿済です。' and return
    else
      @topic = Topic.find(params[:topic_id])
      @neta = @topic.netas.new(create_params)
      if @neta.valid? && @neta.check_hashtags(tag_array)
        Neta.transaction do
          @neta.save
          @neta.add_hashtags(tag_array)
        end
        session[:last_created_at] = Time.zone.now.to_i
        redirect_to neta_path(@neta.id), notice: 'ネタを投稿しました。'
      else
        @stale_form_check_timestamp = Time.zone.now.to_i
        render :new and return
      end
    end
  end

  def show
    @neta = Neta.find(params[:id])
    @owner = @neta.owner(current_user)
    if @neta.private_flag && !@owner
      @message = 'このネタは投稿者が非公開に設定しています。'
    else
      @is_free = @neta.is_free
      @for_sale = @neta.for_sale
      @reviews = @neta.reviews.includes({ user: [image_attachment: :blob] }).order('created_at DESC')
      @myreview = @reviews.find_by(user_id: current_user.id)
      @newreview = Review.new unless @myreview
      unless @owner
        @purchased = @neta.trades.find_by(buyer_id: current_user.id)
        @neta.add_pageview(current_user)
      end
    end
  end

  def edit
    @neta = Neta.find(params[:id])
    redirect_to neta_path(params[:id]), alert: '権限がありません。' and return unless @neta.owner(current_user)

    @editable = @neta.editable
    @qualified = current_user.premium_qualified
    @current_tags = @neta.get_hashtags_str
    @stale_form_check_timestamp = Time.zone.now.to_i
  end

  def update
    if session[:last_created_at].to_i > session_params[:timestamp].to_i
      redirect_to neta_path(params[:id]), alert: '投稿はすでに更新されています。' and return
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
        redirect_to neta_path(params[:id]), notice: 'ネタを更新しました。' and return
      else
        @stale_form_check_timestamp = Time.zone.now.to_i
        @current_tags = @neta.get_hashtags_str
        render :edit and return
      end
    end
  end

  def destroy
    @neta = Neta.includes(:trades, :bookmarks, :reviews, :pageviews, :rankings, :hashtag_netas).find(params[:id])
    if @neta.owner(current_user)
      if @neta.has_dependents
        redirect_to neta_path(params[:id]), alert: 'このネタに属する取引等があるため、削除できません。' and return
      else
        topic_id = @neta.topic_id
        @neta.delete_hashtags
        @neta.destroy!
        redirect_to topic_path(topic_id), notice: 'ネタを削除しました。' and return
      end
    else
      redirect_to neta_path(params[:id]), alert: '削除する権限がありません。' and return
    end
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
    if tag_params['tags'].present?
      tag_str = tag_params['tags']
      tag_str.split(/,/)
    else
      []
    end
  end

  def session_params
    params.require(:neta).permit(:timestamp)
  end

end
