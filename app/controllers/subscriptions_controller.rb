class SubscriptionsController < ApplicationController
  before_action :qualified_user, only: %i[new create]
  before_action :my_info, only: :show

  def new
    @user = current_user
    @customer = @user.get_customer
    if @customer[0]
      @cards = @customer[1]['sources']['data'] if @customer[1]['id'].present?
    end
  rescue StandardError => e
    ErrorUtility.log_and_notify e
    redirect_to user_path(@user.id), alert: e.message and return
  end

  def create
    user = current_user
    res = user.create_cus_from_card(stripe_token)
    if res[0]
      @customer_hash = res[1]
      if @customer_hash['id'].present?
        @subscription_hash = Subscription.create_stripe_sub(@customer_hash['id'], @customer_hash['sources']['data'][0]['id'])
        if @subscription_hash['id'].present?
          Subscription.create!(user_id: user.id, stripe_sub_id: @subscription_hash['id'])
          @card_hash = user.get_card_details(@subscription_hash['default_source'])
        else
          redirect_to new_user_subscription_path(user.id), alert: '定期支払いを登録できませんでした。' and return
        end
      else
        redirect_to new_user_subscription_path(user.id), alert: '顧客情報を取得できませんでした。' and return
      end
    else
      redirect_to new_user_subscription_path(user.id), alert: '顧客情報を取得できませんでした。' and return
    end
  rescue StandardError => e
    ErrorUtility.log_and_notify e
    redirect_to new_user_subscription_path(user.id), alert: e.message and return
  end

  def show
    @user = User.includes(:subscription).find(params[:user_id])
    @subscription_hash = @user.subscription.get_details
    @card_hash = @user.get_card_details(@subscription_hash['default_source'])
    if @subscription_hash['trial_end'].present?
      if Time.zone.now < Time.zone.at(@subscription_hash['trial_end'].to_i)
        @trial_end_date = Time.zone.at(@subscription_hash['trial_end'].to_i)
      end
    end
  rescue StandardError => e
    ErrorUtility.log_and_notify e
    redirect_to user_path(user.id), alert: e.message and return
  end

  private

  def qualified_user
    if current_user.id == params[:user_id].to_i
      redirect_to user_path(params[:user_id]) and return unless current_user.premium_user
    else
      redirect_to user_path(params[:user_id]) and return
    end
  end

  def my_info
    redirect_to user_path(params[:user_id]) and return if current_user.id != params[:user_id].to_i
  end

  def stripe_token
    params[:stripeToken]
  end
end
