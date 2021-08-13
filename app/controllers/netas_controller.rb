# frozen_string_literal: true

class NetasController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show]

  def new
    @topic = Topic.find(params[:topic_id])
    @neta = @topic.netas.new
    @qualified = current_user.premium_qualified
  end

  def create
    @topic = Topic.find(params[:topic_id])
    @neta = @topic.netas.new(create_params)
    if @neta.save_with_hashtags(tag_array)
      redirect_to neta_path(@neta.id), notice: I18n.t('controller.neta.created') and return
    else
      render :new and return
    end
  end

  def show
    @neta = Neta.find(params[:id])
    get_owner
    if @neta.private_flag && !@owner
      @message = I18n.t('controller.neta.private')
    else
      get_reviews
      add_pageview
      get_trades
      @for_sale = @neta.for_sale
    end
  end

  def edit
    @neta = Neta.find(params[:id])
    redirect_to neta_path(params[:id]), alert: I18n.t('controller.general.no_access') and return unless @neta.owner(current_user)
    redirect_to neta_path(params[:id]), alert: I18n.t('controller.neta.dependency') and return unless @neta.editable

    @qualified = current_user.premium_qualified
    @current_tags = @neta.hashtags_str
  end

  def update
    @neta = Neta.find(params[:id])
    @neta.assign_attributes(update_params)
    if @neta.save_with_hashtags(tag_array)
      redirect_to neta_path(@neta.id), notice: I18n.t('controller.neta.updated') and return
    else
      @qualified = current_user.premium_qualified
      @current_tags = @neta.hashtags_str
      render :edit and return
    end
  end

  def destroy
    @neta = Neta.includes(:trades, :bookmarks, :reviews, :pageviews, :rankings, :hashtag_netas).find(params[:id])
    deleteable = delete_check
    if deleteable[0]
      topic_id = @neta.topic_id
      if @neta.delete_with_hashtags
        redirect_to topic_path(topic_id), notice: I18n.t('controller.neta.deleted') and return
      else
        redirect_to neta_path(params[:id]), alert: I18n.t('controller.general.no_access') and return
      end
    else
      redirect_to neta_path(params[:id]), alert: deleteable[1] and return
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

  def delete_check
    if @neta.owner(current_user)
      if @neta.dependents
        [false, I18n.t('controller.neta.undeleteable')]
      else
        [true, nil]
      end
    else
      [false, I18n.t('controller.general.no_access')]
    end
  end

  def get_owner
    @owner = if user_signed_in?
               @neta.owner(current_user)
             else
               false
             end
  end

  def get_reviews
    @reviews = @neta.reviews.includes(:user).order('created_at DESC')
    if user_signed_in?
      @my_review = @reviews.find_by(user_id: current_user.id)
      @new_review = Review.new if @my_review.blank?
    end
  end

  def add_pageview
    @neta.add_pageview(current_user) if user_signed_in?
  end

  def get_trades
    @my_trade = @neta.trades.find_by(buyer_id: current_user.id) if user_signed_in?
  end
end
