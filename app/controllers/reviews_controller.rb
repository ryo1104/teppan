class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    begin
      @neta = Neta.find(params[:neta_id])
      create_params = filter_create_params
      unless create_params == false
        @review = @neta.reviews.create!(create_params)
        update_avg_res = @neta.update_average_rate
        if update_avg_res[0]
          redirect_to neta_path(params[:neta_id]) and return
        else
          Rails.logger.error "Neta::update_average_rate returned false : #{update_avg_res[1]}"
          redirect_to neta_path(params[:neta_id]), alert: "レビューを投稿できませんでした。" and return
        end
      else
        Rails.logger.error "create_params is invalid. Params : #{params}"
        redirect_to neta_path(params[:neta_id]), alert: "レビューを投稿できませんでした。" and return
      end
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to neta_path(params[:neta_id]), alert: "システムエラーによりレビューを投稿できませんでした。" and return
    end 
  end
  
  def show
    begin
      @review = Review.includes(:neta, :comments, {user: [image_attachment: :blob]}).find(params[:id])
      @comments = @review.comments
      @newcomment = Comment.new
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to netas_path, alert: "システムエラーによりレビューを表示できません。" and return
    end
  end

  private
  def filter_create_params
    ret_params = params.require(:review).permit(:text, :rate).merge(user_id: current_user.id)
    puts ret_params
    if ret_params[:rate].blank?
      return false
    else
      return ret_params
    end
  end

end