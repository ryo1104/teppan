# frozen_string_literal: true

class Topics::HeaderimagesController < ApplicationController
  def destroy
    @topic = Topic.find(params[:topic_id])
    if @topic.present?
      if @topic.header_img_url.present?
        object = S3_BUCKET.object(@topic.header_img_url.split('amazonaws.com/')[1])
        if object.delete
          @topic.header_img_url = nil
          @topic.save
        else
          Rails.logger.error "S3 object delete failed. Topic ID : #{@topic.id}"
        end
      else
        Rails.logger.error "topic.header_img_url is blank. Topic ID : #{@topic.id}"
      end
      redirect_to edit_topic_path(@topic.id) and return
    else
      redirect_to topics_path and return
    end
  end
end
