# frozen_string_literal: true

class BookmarksController < ApplicationController
  before_action :load_bookmarkable, only: %i[create destroy]

  def create
    bookmark = @bookmarkable.bookmarks.new(create_params)
    if bookmark.save
      @bookmarkable.reload
    else
      redirect_to user_path(current_user.id) and return
    end
  end

  def destroy
    bookmark = Bookmark.find(params[:id])
    if bookmark.user_id == current_user.id
      if bookmark.destroy
        @bookmarkable.reload
      else
        redirect_to user_path(current_user.id) and return
      end
    else
      redirect_to user_path(current_user.id), alert: I18n.t('controller.general.no_access') and return
    end
  end

  private

  def load_bookmarkable
    @resource, @id = request.path.split('/')[1, 2]
    @bookmarkable = @resource.singularize.classify.constantize.find(@id)
  end

  def create_params
    { 'user_id' => current_user.id }
  end
end
