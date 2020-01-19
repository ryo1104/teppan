class TopicsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  
  def index
    begin
      @search = Topic.includes({user: [image_attachment: :blob]}, :netas).where(private_flag: false).ransack(params[:q])
      @topics = @search.result(distinct: true).order("created_at DESC").page(params[:page]).per(20)
      @hashtag_ranking = Hashtag.get_ranking(10)
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to root_path, alert: "エラーが発生しました。" and return
    end    
  end

  def new
    begin
      @topic = Topic.new
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to topics_path, alert: "エラーが発生しました。" and return
    end
  end
  
  def create
    begin
      @topic = Topic.create!(create_params)
      redirect_to topics_path, notice: "トピックを作成しました。" and return
    rescue ActiveRecord::RecordInvalid => e
      ErrorUtility.log_and_notify e
      redirect_to topics_path, alert: "入力された内容に不備があり保存できませんでした。" and return
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to topics_path, alert: "エラーが発生しました。" and return
    end
  end
  
  def show
    begin
      @topic = Topic.includes({user: [image_attachment: :blob]}).find(params[:id])
      if @topic.private_flag == false || (user_signed_in? && @topic.owner(current_user))
        @netas = @topic.netas.includes({user: [image_attachment: :blob]}, :hashtags).order("created_at DESC")
        @comments = @topic.comments.includes({user: [image_attachment: :blob]}, :likes)
        if user_signed_in?
          @newcomment = Comment.new
          @topic.add_pageview(current_user)
        end
      else
        @message = "この投稿は投稿者が非公開に設定しています。"
      end
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to topics_path, alert: "エラーが発生しました。" and return
    end
  end

  def edit
    begin
      @topic = Topic.find(params[:id])
      unless @topic.owner(current_user)
        redirect_to topic_path(@topic.id), alert: "権限がありません。" and return
      end
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to topic_path(params[:id]), "エラーが発生しました。" and return
    end
  end
  
  def update
    begin
      @topic = Topic.find(params[:id])
      if @topic.owner(current_user)
        if @topic.update!(create_params)
          redirect_to topic_path(@topic.id), notice: "トピックを更新しました。" and return
        else
          redirect_to topic_path(@topic.id), alert: "更新に失敗しました。" and return
        end
      else
        redirect_to topic_path(@topic.id), alert: "権限がありません。" and return
      end
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to topic_path(params[:id]), alert: "エラーが発生しました。" and return
    end
  end
  
  def destroy
    begin
      @topic = Topic.includes(:netas, :pageviews, :interests).find(params[:id])
      if @topic.owner(current_user)
        if @topic.is_deleteable
          if @topic.destroy!
            redirect_to topics_path, notice: "トピックを削除しました。" and return
          else
            redirect_to topic_path(@topic.id), alert: "更新に失敗しました。" and return
          end
        else
          redirect_to topic_path(@topic.id), alert: "このトピックに属する投稿があるため、削除できません。" and return
        end
      else
        redirect_to topic_path(@topic.id), alert: "削除する権限がありません。" and return
      end
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to topic_path(params[:id]), alert: "エラーが発生しました。" and return
    end
  end
  
  def delete_header_image
    @topic = Topic.find(params[:topic_id])
    if @topic.header_image.attached?
      @topic.header_image.purge
    end
    redirect_to edit_topic_path(@topic.id) and return
  end
  
  private
  def create_params
    params.require(:topic).permit(:title, :content, :header_image, :private_flag).merge(user_id: current_user.id)
  end
  
end
