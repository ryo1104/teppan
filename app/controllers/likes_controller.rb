# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :load_likeable, only: %i[create destroy]

  def create
    like = @likeable.likes.new(create_params)
    if like.save
      @likeable.reload
    else
      redirect_to user_path(current_user.id) and return
    end
  end

  def destroy
    like = Like.find(params[:id])
    if like.user_id == current_user.id
      if like.destroy
        @likeable.reload
      else
        redirect_to user_path(current_user.id) and return
      end
    else
      redirect_to user_path(current_user.id), alert: I18n.t('controller.general.no_access') and return
    end
  end

  private

  def load_likeable
    @resource, @id = request.path.split('/')[1, 2]
    @likeable = @resource.singularize.classify.constantize.find(@id)
  end

  def create_params
    { 'user_id' => current_user.id }
  end
end
