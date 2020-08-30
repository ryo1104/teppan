class UsersController < ApplicationController
  def show
    get_user(params[:id])

    if my_page
      redirect_to edit_user_path(@user.id) if @user.nickname.blank?
      @draft_netas = @user.netas.includes(:hashtags, :user).where(private_flag: true)
      @draft_topics = @user.topics.includes([header_image_attachment: :blob], :netas, :user).where(private_flag: true)
      @following_users_count = @user.following_users_count
      @bought_trades = Trade.where(buyer_id: @user.id, tradeable_type: 'Neta')
      @bought_netas = User.bought_netas(@bought_trades)
      @bookmarked_netas = @user.bookmarked_netas
      @bookmarked_topics = @user.bookmarked_topics
      @account_exists = true if @user.account.present?
      @sold_netas_info = @user.get_sold_netas_info if @account_exists
    end

    @premium_user = @user.premium_user
    @userrate = @user.average_rate
    # @lastlogin = @user.current_sign_in_at
    @posted_netas = @user.netas.includes(:reviews, :hashtags, :user).where(private_flag: false)
    @posted_topics = @user.topics.includes([header_image_attachment: :blob], :netas, :user).where(private_flag: false)
    @followed_users_count = @user.follows_count
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
    params.require(:user).permit(:nickname, :image, :birthdate, :gender, :introduction)
  end

  def my_page
    @my_page = @user.id == current_user.id
    @my_page
  end
end
