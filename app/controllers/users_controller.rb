# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_s3_direct_post, only: %i[edit]

  def show
    get_user(params[:id])
    get_posted_info
    if my_page
      redirect_to edit_user_path(@user.id) and return if @user.nickname.blank?

      get_draft_info
      get_bookmarked_info
      get_traded_info
      get_stripe_info
    end
    get_counts
  end

  def edit
    get_user(params[:id])
    redirect_to user_path(@user.id), alert: I18n.t('controller.general.no_access') and return unless my_page
  end

  def update
    get_user(params[:id])
    redirect_to user_path(@user.id), alert: I18n.t('controller.general.no_access') and return unless my_page

    @user.purge_s3_object if update_params[:avatar_img_url].present?
    if @user.update(update_params)
      redirect_to user_path(@user.id), notice: I18n.t('controller.user.profile.updated') and return
    else
      render :edit
    end
  end

  private

  def get_user(id)
    @user = User.includes(:netas).find(id)
    @premium_user = @user.premium_user
    @userrate = @user.average_rate
  end

  def update_params
    params.require(:user).permit(:nickname, :avatar_img_url, :birthdate, :gender, :introduction)
  end

  def my_page
    @my_page = @user.id == current_user.id
  end

  def get_posted_info
    @posted_netas = @user.netas.where(private_flag: false)
    @posted_topics = @user.topics.includes(:netas).where(private_flag: false)
  end

  def get_draft_info
    @draft_netas = @user.netas.where(private_flag: true)
    @draft_topics = @user.topics.includes(:netas).where(private_flag: true)
  end

  def get_traded_info
    @bought_trades = Trade.where(buyer_id: @user.id, tradeable_type: 'Neta')
    @bought_netas = User.bought_netas(@bought_trades)
    @sold_netas_info = Trade.get_trades_info('seller', @user.id, 'Neta')
  end

  def get_bookmarked_info
    @bookmarked_netas = @user.bookmarked_netas
    @bookmarked_topics = @user.bookmarked_topics
  end

  def get_stripe_info
    @account_exists = true if @user.stripe_account.present?
  end

  def get_counts
    @posted_netas_count = @posted_netas.present? ? @posted_netas.count : 0
    @draft_netas_count = @draft_netas.present? ? @draft_netas.count : 0
    @posted_topics_count = @posted_topics.present? ? @posted_topics.count : 0
    @draft_topics_count = @draft_topics.present? ? @draft_topics.count : 0
    @bought_netas_count = @bought_netas.present? ? @bought_netas.count : 0
    @bookmarked_netas_count = @bookmarked_netas.present? ? @bookmarked_netas.count : 0
    @bookmarked_topics_count = @bookmarked_topics.present? ? @bookmarked_topics.count : 0
    @followed_users_count = @user.followers_count
    @following_users_count = @user.followings_count
  end

  def set_s3_direct_post
    @s3_direct_post = S3_BUCKET.presigned_post(key: "user_avatar_images/#{SecureRandom.uuid}/${filename}",
                                               success_action_status: '201', acl: 'public-read')
  end
end
