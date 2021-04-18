class TopicsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_s3_direct_post, only: [:new, :edit, :create, :update, :destroy]

  def index
    @search = Topic.includes(:user, :netas).where(private_flag: false).ransack(params[:q])
    @topic_cards = @search.result(distinct: true).order('created_at DESC').page(params[:page]).per(20)
    @hashtag_ranking = Hashtag.get_ranking(10)
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new(post_params)
    if @topic.save
      redirect_to topics_path, notice: I18n.t('controller.topic.created') and return
    else
      render :new and return
    end
  end

  def show
    @topic = Topic.includes(:user).find(params[:id])
    @owner = owner(@topic)
    if @topic.private_flag && !@owner
      @message = I18n.t('controller.topic.private')
    else
      @netas = @topic.netas.includes(:user, :hashtags).where(private_flag: false).order('average_rate DESC')
      @comments = @topic.comments.includes(:user).order('created_at DESC')
      if user_signed_in?
        @newcomment = Comment.new
        @topic.add_pageview(current_user)
      end
    end
  end

  def edit
    @topic = Topic.find(params[:id])
    redirect_to topic_path(@topic.id), alert: I18n.t('controller.general.no_access') and return unless owner(@topic)
  end

  def update
    @topic = Topic.find(params[:id])
    if owner(@topic)
      if @topic.update(post_params)
        redirect_to topic_path(@topic.id), notice: I18n.t('controller.topic.updated') and return
      else
        render :edit and return
      end
    else
      redirect_to topic_path(@topic.id), alert: I18n.t('controller.general.no_access') and return
    end
  end

  def destroy
    @topic = Topic.includes(:netas, :pageviews, :bookmarks).find(params[:id])
    if owner(@topic)
      if @topic.deleteable
        if @topic.destroy
          redirect_to topics_path, notice: I18n.t('controller.topic.deleted') and return
        else
          render :edit and return
        end
      else
        redirect_to topic_path(@topic.id), alert: I18n.t('controller.topic.has_child') and return
      end
    else
      redirect_to topic_path(@topic.id), alert: I18n.t('controller.general.no_access') and return
    end
  end

  private

  def post_params
    params.require(:topic).permit(:title, :content, :header_img_url, :private_flag).merge(user_id: current_user.id)
  end

  def owner(topic)
    if user_signed_in?
      topic.owner(current_user)
    else
      false
    end
  end

  def set_s3_direct_post
    @s3_direct_post = S3_BUCKET.presigned_post(key: "topic_header_images/#{SecureRandom.uuid}/${filename}",
                                               success_action_status: '201', acl: 'public-read')
  end

end
