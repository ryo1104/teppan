class ViolationsController < ApplicationController
  def new
    @user = User.find(params[:user_id])
    @violation = Violation.new
  rescue StandardError => e
    ErrorUtility.log_and_notify e
    redirect_to user_path(params[:user_id]), 'システムエラーが発生しました。' and return
  end

  def create
    @violater = User.find(params[:user_id])
    if @violater.violations.find_by(reporter_id: current_user.id).present?
      Rails.logger.error "Violation already exists for user_id: #{@violater.id}, reporter_id: #{current_user.id}."
      redirect_to user_path(current_user.id), alert: '対象ユーザーの違反報告はすでに存在します。' and return
    else
      Violation.create!(create_params)
      follow = @violater.follows.find_by(follower_id: current_user.id)
      follow.destroy! if follow.present?
      redirect_to user_path(@violater.id), notice: "#{@violater.nickname}さんに対する違反報告を受け付けました。" and return
      end
  rescue StandardError => e
    ErrorUtility.log_and_notify e
    redirect_to user_path(params[:user_id]), alert: 'システムエラーにより違反報告を登録できませんでした。' and return
  end

  private

  def create_params
    params.require(:violation).permit(:text, :block).merge(user_id: params[:user_id], reporter_id: current_user.id)
  end
end
