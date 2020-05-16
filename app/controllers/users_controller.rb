class UsersController < ApplicationController
  def show
    begin
      @user = User.includes({netas: [:reviews, :hashtags]}, :interests).find(params[:id])
      @my_page = true unless @user.id != current_user.id
      redirect_to edit_user_path(@user.id) if @my_page && @user.nickname.blank?
      @premium_user = @user.premium_user
      @userrate = @user.average_rate
      # @lastlogin = @user.current_sign_in_at
      @posted_netas = @user.netas.includes(:reviews, :hashtags, :user).where(private_flag: false)
      @posted_topics = @user.topics.includes([header_image_attachment: :blob], :netas, :user).where(private_flag: false)
      @followed_users_count = @user.follows_count
      
      if @my_page
        @draft_netas = @user.netas.includes(:hashtags, :user).where(private_flag: true)
        @following_users_count = @user.following_users_count
        @bought_trades = Trade.where(buyer_id: @user.id, tradeable_type: "Neta")
        @bought_netas = User.bought_netas(@bought_trades)
        @interested_netas = @user.interested_netas
        @interested_topics = @user.interested_topics
        @account_exists = true if @user.account.present?
        if @account_exists
          @sold_netas_info = @user.get_sold_netas_info
        end
      end
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to root_path, alert: e.message and return
    end
  end
  
  def edit
    @user = User.find(params[:id])
    @my_page = true if @user.id == current_user.id
    if @my_page
      if @user.nickname.blank?
        @no_nickname = true 
        @temp_nickname = @user.email.split('@')[0]
      end
      @profile_gauge = @user.profile_gauge
    else
      redirect_to user_path(@user.id), alert: "編集権限がありません。" and return
    end
  end
  
  def update
    begin
      @user = User.find(params[:id])
      @my_page = true if @user.id == current_user.id
      if @my_page
        @user.update!(update_params)
        redirect_to user_path(@user.id), notice: "プロフィールを更新しました。" and return
      else
        redirect_to user_path(@user.id), alert: "更新権限がありません。" and return
      end
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to user_path(params[:id]), alert: e.message and return
    end
  end
  
  def delete_avatar
    @user = User.find(params[:id])
    if @user.id == current_user.id
      if @user.image.attached?
        @user.image.purge
      end
    end
    redirect_to edit_user_path(@user.id) and return
  end
  
  private
  def update_params
    params.require(:user).permit(:nickname, :image, :birthdate, :gender, :prefecture_code, :introduction)
  end
end
