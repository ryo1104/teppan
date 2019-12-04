class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_likeable
  
  def create
    begin
      @like = @likeable.likes.create!(create_params)
      @likeable.reload
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to "/#{@likeable.class.name.pluralize.downcase}/#{@likeable.id}", alert: "システムエラーが発生しました。" and return
    end
  end
  
  def destroy
    begin
      @like = Like.find(params[:id])
      if @like.user_id == current_user.id
        @like.destroy!
        @likeable.reload
      else
        redirect_to "/#{@likeable.class.name.pluralize.downcase}/#{@likeable.id}", alert: "他のユーザーのいいねは削除できません。" and return
      end
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to "/#{@likeable.class.name.pluralize.downcase}/#{@likeable.id}", "システムエラーが発生しました。" and return
    end
  end
  
  private
  def load_likeable
    @resource, @id = request.path.split('/')[1, 2]
    @likeable = @resource.singularize.classify.constantize.find(@id)
  end
  
  def create_params
    hash = { "user_id" => current_user.id }
    return hash
  end
end
