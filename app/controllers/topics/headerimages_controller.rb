# frozen_string_literal: true

class Topics::HeaderimagesController < ApplicationController
  def destroy
    @topic = Topic.find(params[:topic_id])
    if @topic.present?
      if @topic.header_img_url.present?
        @topic.header_img_url = nil
        @topic.save!
      else
        logger.error "topic.header_img_url is blank. Topic ID : #{@topic.id}"
      end
      redirect_to edit_topic_path(@topic.id) and return
    else
      redirect_to topics_path and return
    end
  end
end
