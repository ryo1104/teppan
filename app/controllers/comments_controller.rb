class CommentsController < ApplicationController
  before_action :load_commentable, only: %i[create destroy]

  def create
    @comment = @commentable.comments.new(create_params)
    if @comment.save
      redirect_to "/#{@commentable.class.name.pluralize.downcase}/#{@commentable.id}"
    else
      redirect_to "/#{@commentable.class.name.pluralize.downcase}/#{@commentable.id}", alert: "コメントを投稿できませんでした。" and return
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    if @comment.user_id == current_user.id
      if @comment.update(is_deleted: true)
        redirect_to "/#{@commentable.class.name.pluralize.downcase}/#{@commentable.id}" and return
      else
        redirect_to "/#{@commentable.class.name.pluralize.downcase}/#{@commentable.id}", alert: "コメントを削除できませんでした。" and return
      end
    else
      redirect_to "/#{@commentable.class.name.pluralize.downcase}/#{@commentable.id}", alert: "他のユーザーのコメントは削除できません。" and return
    end
  end
  
  private
  def load_commentable
    @parent_resource, @parent_id = request.path.split('/')[1, 2]
    @commentable = @parent_resource.singularize.classify.constantize.find(@parent_id)
  end
  
  def create_params
    params.require(:comment).permit(:text).merge(user_id: current_user.id, is_deleted: false)
  end
end
