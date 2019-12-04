class InterestsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_interestable
  
  def create
    begin
      interest = @interestable.interests.new(create_params)
      interest.save!
      @interestable.reload
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to "/#{@interestable.class.name.pluralize.downcase}/#{@interestable.id}", alert: e.message and return
    end
  end
  
  def destroy
    begin
      interest = Interest.find(params[:id])
      if interest.user_id == current_user.id
        interest.destroy!
        @interestable.reload
      else
        redirect_to "/#{@interestable.class.name.pluralize.downcase}/#{@interestable.id}", alert: "他のユーザーのお気に入りは削除できません。" and return
      end
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to "/#{@interestable.class.name.pluralize.downcase}/#{@interestable.id}", alert: e.message and return
    end
  end

  private
  def load_interestable
    @resource, @id = request.path.split('/')[1, 2]
    @interestable = @resource.singularize.classify.constantize.find(@id)
  end
  
  def create_params
    hash = { "user_id" => current_user.id }
    return hash
  end

end
