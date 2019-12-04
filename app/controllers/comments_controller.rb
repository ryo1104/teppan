class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: :create

  def create
    begin
      @comment = @commentable.comments.new(create_params)
      @comment.save!
      redirect_to "/#{@commentable.class.name.pluralize.downcase}/#{@commentable.id}" and return
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to "/#{@commentable.class.name.pluralize.downcase}/#{@commentable.id}", alert: e.message and return
    end
  end
  
  def destroy
    begin
      @comment = Comment.find(params[:id])
      @commentable_type = @comment.commentable_type.pluralize.downcase
      @commentable_id = @comment.commentable_id
      if @comment.user_id == current_user.id
        @comment.update!(text: "（このコメントは削除されました）")
        redirect_to "/#{@commentable_type}/#{@commentable_id}" and return
      else
        redirect_to "/#{@commentable_type}/#{@commentable_id}", alert: "他のユーザーのコメントは削除できません。" and return
      end
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to "/#{@commentable_type}/#{@commentable_id}", alert: e.message and return
    end

  end
  
  private
  def load_commentable
    @resource, @id = request.path.split('/')[1, 2]
    @commentable = @resource.singularize.classify.constantize.find(@id)
  end
  
  def create_params
    params.require(:comment).permit(:text).merge(user_id: current_user.id)
  end
end
