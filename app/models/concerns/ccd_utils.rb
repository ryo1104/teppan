# frozen_string_literal: true

module CcdUtils
  extend ActiveSupport::Concern
  require 'net/http'
  require 'uri'
  require 'json'
  require 'openssl'

  included do
    @ccd_api_key = ENV['CCD_SECRET_KEY']
    @ccd_post_path = ENV['CCD_POST_PATH']
    @ccd_res_path = ENV['CCD_RES_PATH']
    @ccd_res_detail_path = ENV['CCD_RES_DETAIL_PATH']
  end
end
