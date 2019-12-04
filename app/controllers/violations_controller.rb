class ViolationsController < ApplicationController
  before_action :authenticate_user!
  
  def new
    begin
      @user = User.find(params[:user_id])
      @violation = Violation.new
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to user_path(params[:user_id]), "システムエラーが発生しました。" and return
    end
  end
  
  def create
    begin
      @violater = User.find(params[:user_id])
      unless @violater.violations.find_by(reporter_id: current_user.id).present?
        Violation.create!(create_params)
        follow = @violater.follows.find_by(follower_id: current_user.id)
        if follow.present?
          follow.destroy!
        end
        redirect_to user_path(@violater.id), notice: "#{@violater.nickname}さんに対する違反報告を受け付けました。" and return
      else
        Rails.logger.error "Violation already exists for user_id: #{@violater.id}, reporter_id: #{current_user.id}."
        redirect_to user_path(current_user.id), alert: "対象ユーザーの違反報告はすでに存在します。" and return
      end
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to user_path(params[:user_id]), alert: "システムエラーにより違反報告を登録できませんでした。" and return
    end
  end
  
  private
  
  def create_params
    params.require(:violation).permit(:text, :block).merge(user_id: params[:user_id], reporter_id: current_user.id)
  end
end
