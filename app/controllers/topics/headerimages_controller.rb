class Topics::HeaderimagesController < ApplicationController

  def destroy
    @topic = Topic.find(params[:topic_id])
    if @topic.header_img_url.present?
      object = S3_BUCKET.object(@topic.header_img_url.split('amazonaws.com/')[1])
      if object.delete
        @topic.header_img_url = nil
        @topic.save
      end
    end
    redirect_to edit_topic_path(@topic.id) and return
  end
end
