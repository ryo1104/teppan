class LikesController < ApplicationController
  before_action :load_likeable

  def create
    @like = @likeable.likes.create!(create_params)
    @likeable.reload
  rescue StandardError => e
    ErrorUtility.log_and_notify e
    redirect_to "/#{@likeable.class.name.pluralize.downcase}/#{@likeable.id}", alert: 'システムエラーが発生しました。' and return
  end

  def destroy
    @like = Like.find(params[:id])
    if @like.user_id == current_user.id
      @like.destroy!
      @likeable.reload
    else
      redirect_to "/#{@likeable.class.name.pluralize.downcase}/#{@likeable.id}", alert: '他のユーザーのいいねは削除できません。' and return
    end
  rescue StandardError => e
    ErrorUtility.log_and_notify e
    redirect_to "/#{@likeable.class.name.pluralize.downcase}/#{@likeable.id}", 'システムエラーが発生しました。' and return
  end

  private

  def load_likeable
    @resource, @id = request.path.split('/')[1, 2]
    @likeable = @resource.singularize.classify.constantize.find(@id)
  end

  def create_params
    hash = { 'user_id' => current_user.id }
    hash
  end
end
