# frozen_string_literal: true

class Copycheck < ApplicationRecord
  include CcdUtils
  belongs_to :neta

  def post_ccd_check(text)
    if text.present?

      uri = URI.parse(@ccd_post_path)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      req = Net::HTTP::Post.new(uri.request_uri)
      req['Authorization'] = "bearer #{@ccd_api_key}"

      data = {
        'key' => @ccd_api_key.to_s,
        'text' => text.to_s
      }
      req.set_form_data(data)
      res = http.request(req)
      JSON.parse(res.body)

    end
  end

  def get_ccd_result(queue_id)
    data = {
      'key' => @ccd_api_key.to_s,
      'queue_id' => queue_id.to_s
    }

    uri = URI.parse(@ccd_res_path)
    uri.query = data.to_query

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Get.new(uri.request_uri)
    req['Authorization'] = "bearer #{@ccd_api_key}"

    req.set_form_data(data)
    res = http.request(req)

    JSON.parse(res.body)
  end

  def get_ccd_result_detail(queue_id)
    data = {
      'key' => @ccd_api_key.to_s,
      'queue_id' => queue_id.to_s,
      'devide_string_flg' => '0',
      'sequence_string_flg' => '0'
    }

    uri = URI.parse(@ccd_res_detail_path)
    uri.query = data.to_query

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Get.new(uri.request_uri)
    req['Authorization'] = "bearer #{@ccd_api_key}"

    req.set_form_data(data)
    res = http.request(req)

    JSON.parse(res.body)
  end

  def save_weblike_list(web_like_list)
    web_like_list.each do |web_like|
      url = web_like['url'].to_s
      web_like['string_list'].each_with_index do |item, i|
        distance = web_like['distance_list'][i].to_i
        text = item.to_s
        CopycheckWeblike.create(queue_id: queue_id, url: url, distance: distance, text: text)
      end
    end
  end

  def save_textlike_list(text_match_list)
    text_match_list.each do |text_match|
      like_queue_id = text_match['queue_id'].to_i
      percent = text_match['percent'].to_i
      CopycheckTextlike.create(queue_id: queue_id, like_queue_id: like_queue_id, percent: percent)
    end
  end
end
