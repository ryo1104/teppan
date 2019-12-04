class CopychecksController < ApplicationController
  def new
    @check_obj = Copycheck.new
  end
  
  def create
    @text_to_send = params.require(:copycheck)[:text]
    @check_obj = Copycheck.create(create_params)
    
    @ccd_post_result = @check_obj.post_ccd_check(@text_to_send)
    if @ccd_post_result["status"] == 1
      @check_obj.update(queue_id: @ccd_post_result["queue_id"])
    else
      @ccd_error_code = @ccd_post_result["status"]
      @ccd_error_message = @ccd_post_result["error"]["message"]
      @ccd_error_validation = @ccd_post_result["error"]["validate"]["text"]
      @check_obj.delete
    end
  end
  
  def index
    @check_objs = Copycheck.all
    @check_status = CopycheckStatus.all
  end
  
  def show
    @check_obj = Copycheck.find(params[:id])
    @check_status = CopycheckStatus.all
    if @check_obj.queue_id.present?
      @web_like_list = CopycheckWeblike.where(queue_id: @check_obj.queue_id)
      @text_like_list = CopycheckTextlike.where(queue_id: @check_obj.queue_id)
    end
  end
  
  def update
    @check_obj = Copycheck.find(params[:id])
    
    unless @check_obj.queue_id.present?

      @ccd_post_result = @check_obj.post_ccd_check(@check_obj.text)
      
      if @ccd_post_result["status"] == 1
        @check_obj.update(queue_id: @ccd_post_result["queue_id"])
        redirect_to copycheck_path
      else
        @ccd_error_code = @ccd_post_result["status"]
        @ccd_error_message = @ccd_post_result["error"]["message"]
        @ccd_error_validation = @ccd_post_result["error"]["validate"]
      end
      
    else

      @ccd_query_result = @check_obj.get_ccd_result(@check_obj.queue_id)
      if @ccd_query_result["status"] == 1
        @check_obj.update(web_like_status: @ccd_query_result["result_data"]["web_like_info"]["like_status"],
                          web_like_percent: @ccd_query_result["result_data"]["web_like_info"]["like_percent"],
                          web_match_status: @ccd_query_result["result_data"]["web_match_info"]["match_status"],
                          web_match_percent: @ccd_query_result["result_data"]["web_match_info"]["match_percent"],
                          text_match_status: @ccd_query_result["result_data"]["text_match_info"]["text_match_status"],
                          text_match_percent: @ccd_query_result["result_data"]["text_match_info"]["text_match_percent"])
      else
        @ccd_error_code = @ccd_query_result["status"]
        @ccd_error_message = @ccd_query_result["error"]["message"]
      end
        
      @ccd_query_result_detail = @check_obj.get_ccd_result_detail(@check_obj.queue_id)
      if @ccd_query_result_detail["status"] == 1
        @check_obj.save_weblike_list(@ccd_query_result_detail["result_data"]["web_like_list"])
        @check_obj.save_textlike_list(@ccd_query_result_detail["result_data"]["text_match_list"])
      else
        @ccd_detail_error_code = @ccd_query_result_detail["status"]
        @ccd_detail_error_message = @ccd_query_result_detail["error"]["message"]
      end
  
      if @ccd_query_result["status"] == 1 && @ccd_query_result_detail["status"] == 1
        redirect_to copycheck_path
      end
    end
  end
  
  private
  def create_params
    params.require(:copycheck).permit(:text)
  end

end

# {"status"=>1, "result_data"=>{
#                 "web_like_info"=>{"like_status"=>"3", "like_percent"=>"100"}, 
#                 "web_match_info"=>{"match_status"=>"3", "match_percent"=>"98"}, 
#                 "text_match_info"=>{"text_match_status"=>"3", "text_match_percent"=>"100"}
#               }
# }