class UsersController < ApplicationController
  before_action :set_s3_direct_post, only: [:edit, :update]

  def show
    get_user(params[:id])
    @premium_user = @user.premium_user
    @userrate = @user.average_rate
    # @lastlogin = @user.current_sign_in_at
    @posted_netas = @user.netas.includes(:reviews, :hashtags, :user).where(private_flag: false)
    @posted_topics = @user.topics.includes(:netas, :user).where(private_flag: false)
    if my_page
      redirect_to edit_user_path(@user.id) if @user.nickname.blank?
      @draft_netas = @user.netas.includes(:hashtags, :user).where(private_flag: true)
      @draft_topics = @user.topics.includes(:netas, :user).where(private_flag: true)
      @bought_trades = Trade.where(buyer_id: @user.id, tradeable_type: 'Neta')
      @bought_netas = User.bought_netas(@bought_trades)
      @bookmarked_netas = @user.bookmarked_netas
      @bookmarked_topics = @user.bookmarked_topics
      @account_exists = true if @user.stripe_account.present?
      @sold_netas_info = Trade.get_trades_info('seller', @user.id, 'Neta') if @account_exists
    end
    get_counts
  end

  def edit
    get_user(params[:id])
    redirect_to user_path(@user.id), alert: '権限がありません。' and return unless my_page
  end

  def update
    get_user(params[:id])
    if my_page
      if @user.update(update_params)
        redirect_to user_path(@user.id), notice: 'プロフィールを更新しました。' and return
      else
        render :edit
      end
    else
      redirect_to user_path(@user.id), alert: '権限がありません。' and return
    end
  end

  private

  def get_user(id)
    @user = User.includes({ netas: %i[reviews hashtags] }, :bookmarks).find(id)
  end

  def update_params
    params.require(:user).permit(:nickname, :avatar_img_url, :birthdate, :gender, :introduction)
  end

  def my_page
    @my_page = @user.id == current_user.id
  end

  def get_counts
    @posted_netas_count = @posted_netas.present? ? @posted_netas.count : 0
    @draft_netas_count = @draft_netas.present? ? @draft_netas.count : 0
    @posted_topics_count = @posted_topics.present? ? @posted_topics.count : 0
    @draft_topics_count = @draft_topics.present? ? @draft_topics.count : 0
    @bought_netas_count = @bought_netas.present? ? @bought_netas.count : 0
    @bookmarked_netas_count = @bookmarked_netas.present? ? @bookmarked_netas.count : 0
    @bookmarked_topics_count = @bookmarked_topics.present? ? @bookmarked_topics.count : 0
    @followed_users_count = @user.follows_count
    @following_users_count = @user.following_users_count
  end

  def set_s3_direct_post
    @s3_direct_post = S3_BUCKET.presigned_post(key: "user_avatar_images/#{SecureRandom.uuid}/${filename}",
                                               success_action_status: '201', acl: 'public-read')
  end
end
