class Topics::HeaderimagesController < ApplicationController

  def destroy
    @topic = Topic.find(params[:topic_id])
    if @topic.header_image.attached?
      @topic.header_image.purge
    end
    redirect_to edit_topic_path(@topic.id) and return
  end

end