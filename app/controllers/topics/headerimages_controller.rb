class Topics::HeaderimagesController < ApplicationController
  def destroy
    @topic = Topic.find(params[:topic_id])
    @topic.header_image.purge if @topic.header_image.attached?
    redirect_to edit_topic_path(@topic.id) and return
  end
end
