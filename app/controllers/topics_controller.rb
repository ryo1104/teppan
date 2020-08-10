class TopicsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  
  def index
    @search = Topic.includes([header_image_attachment: :blob], {user: [image_attachment: :blob]}, :netas).where(private_flag: false).ransack(params[:q])
    @topic_cards = @search.result(distinct: true).order("created_at DESC").page(params[:page]).per(5)
    @hashtag_ranking = Hashtag.get_ranking(10)
  end

  def new
    @topic = Topic.new
  end
  
  def create
    @topic = Topic.new(post_params)
    if @topic.save
      redirect_to topics_path, notice: "トピックを作成しました。" and return
    else
      render :new and return
    end
  end
  
  def show
    @topic = Topic.includes({user: [image_attachment: :blob]}).find(params[:id])
    @owner = owner(@topic)
    if @topic.private_flag && @owner == false
      @message = "この投稿は非公開に設定されています。"
    else
      @netas = @topic.netas.includes({user: [image_attachment: :blob]}, :hashtags).where(private_flag: false).order("average_rate DESC")
      @comments = @topic.comments.includes({user: [image_attachment: :blob]}).order("created_at DESC")
      if user_signed_in?
        @newcomment = Comment.new
        @topic.add_pageview(current_user)
      end
    end
  end

  def edit
    @topic = Topic.find(params[:id])
    unless owner(@topic)
      redirect_to topic_path(@topic.id), alert: "権限がありません。" and return
    end
  end
  
  def update
    @topic = Topic.find(params[:id])
    if owner(@topic)
      if @topic.update(post_params)
        redirect_to topic_path(@topic.id), notice: "トピックを更新しました。" and return
      else
        render :edit and return
      end
    else
      redirect_to topic_path(@topic.id), alert: "権限がありません。" and return
    end
  end
  
  def destroy
    @topic = Topic.includes(:netas, :pageviews, :bookmarks).find(params[:id])
    if owner(@topic)
      if @topic.destroy
        redirect_to topics_path, notice: "トピックを削除しました。" and return
      else
        render :edit and return
      end
    else
      redirect_to topic_path(@topic.id), alert: "権限がありません。" and return
    end
  end
  
  private
  
  def post_params
    params.require(:topic).permit(:title, :content, :header_image, :private_flag).merge(user_id: current_user.id)
  end
  
  def owner(topic)
    if user_signed_in?
      return topic.owner(current_user)
    else
      return false
    end
  end
  
end
