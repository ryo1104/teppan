# frozen_string_literal: true

class NetasController < ApplicationController
  def new
    @topic = Topic.find(params[:topic_id])
    @neta = @topic.netas.new
    @qualified = current_user.premium_qualified
  end

  def create
    @topic = Topic.find(params[:topic_id])
    @neta = @topic.netas.new(create_params)
    if @neta.valid? && @neta.check_hashtags(tag_array)
      Neta.transaction do
        @neta.save!
        @neta.add_hashtags(tag_array)
      end
      redirect_to neta_path(@neta.id), notice: I18n.t('controller.neta.created') and return
    else
      render :new and return
    end
  end

  def show
    @neta = Neta.find(params[:id])
    @owner = @neta.owner(current_user)
    if @neta.private_flag && !@owner
      @message = I18n.t('controller.neta.private')
    else
      @for_sale = @neta.for_sale
      @reviews = @neta.reviews.includes(:user).order('created_at DESC')
      @my_review = @reviews.find_by(user_id: current_user.id)
      @new_review = Review.new if @my_review.blank?
      @my_trade = @neta.trades.find_by(buyer_id: current_user.id)
      @neta.add_pageview(current_user)
    end
  end

  def edit
    @neta = Neta.find(params[:id])
    redirect_to neta_path(params[:id]), alert: I18n.t('controller.general.no_access') and return unless @neta.owner(current_user)
    redirect_to neta_path(params[:id]), alert: I18n.t('controller.neta.dependency') and return unless @neta.editable

    @qualified = current_user.premium_qualified
    @current_tags = @neta.get_hashtags_str
  end

  def update
    @neta = Neta.find(params[:id])
    @neta.assign_attributes(update_params)
    if @neta.valid? && @neta.check_hashtags(tag_array)
      Neta.transaction do
        @neta.save!
        @neta.delete_hashtags
        @neta.add_hashtags(tag_array)
      end
      redirect_to neta_path(params[:id]), notice: I18n.t('controller.neta.updated') and return
    else
      @qualified = current_user.premium_qualified
      @current_tags = @neta.get_hashtags_str
      render :edit and return
    end
  end

  def destroy
    @neta = Neta.includes(:trades, :bookmarks, :reviews, :pageviews, :rankings, :hashtag_netas).find(params[:id])
    if @neta.owner(current_user)
      if @neta.dependents
        redirect_to neta_path(params[:id]), alert: I18n.t('controller.neta.undeleteable') and return
      else
        topic_id = @neta.topic_id
        Neta.transaction do
          @neta.delete_hashtags
          @neta.destroy!
        end
        redirect_to topic_path(topic_id), notice: I18n.t('controller.neta.deleted') and return
      end
    else
      redirect_to neta_path(params[:id]), alert: I18n.t('controller.general.no_access') and return
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
