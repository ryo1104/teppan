# frozen_string_literal: true

class Copycheck < ApplicationRecord
  belongs_to :neta

  require 'net/http'
  require 'uri'
  require 'json'
  require 'openssl'
  require 'active_support'
  require 'active_support/core_ext'

  def post_ccd_check(text)
    ccd_post_path = 'https://member.ccd.tokyo/UserApiV1/postText'
    apikey = '907b6397dae8401966290fd7579ba768'

    if text.present?

      uri = URI.parse(ccd_post_path)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      req = Net::HTTP::Post.new(uri.request_uri)
      req['Authorization'] = "bearer #{apikey}"

      data = {
        'key' => apikey.to_s,
        'text' => text.to_s
      }
      req.set_form_data(data)
      res = http.request(req)
      obj = JSON.parse(res.body)

      # puts "コピーチェック登録："
      # puts obj
      obj

    end
  end

  def get_ccd_result(queue_id)
    ccd_result_path = 'https://member.ccd.tokyo/UserApiV1/getResult'
    apikey = '907b6397dae8401966290fd7579ba768'

    data = {
      'key' => apikey.to_s,
      'queue_id' => queue_id.to_s
    }

    uri = URI.parse(ccd_result_path)
    uri.query = data.to_query

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Get.new(uri.request_uri)
    req['Authorization'] = "bearer #{apikey}"

    req.set_form_data(data)
    res = http.request(req)

    obj = JSON.parse(res.body)

    # puts "コピーチェック照会："
    # puts obj
    obj
  end

  def get_ccd_result_detail(queue_id)
    ccd_result_path = 'https://member.ccd.tokyo/UserApiV1/getDetail'
    apikey = '907b6397dae8401966290fd7579ba768'

    data = {
      'key' => apikey.to_s,
      'queue_id' => queue_id.to_s,
      'devide_string_flg' => '0',
      'sequence_string_flg' => '0'
    }

    uri = URI.parse(ccd_result_path)
    uri.query = data.to_query

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Get.new(uri.request_uri)
    req['Authorization'] = "bearer #{apikey}"

    req.set_form_data(data)
    res = http.request(req)

    obj = JSON.parse(res.body)

    obj
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
