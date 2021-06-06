# frozen_string_literal: true

module JpUtils
  extend ActiveSupport::Concern
  require 'nkf'

  class JpKana
    def self.hankaku(str)
      if str.nil?
        nil
      else
        NKF.nkf('-w -Z4', str)
      end
    end

    def self.hiragana(str)
      # 全角ひらがな、または英数字
      if str.match(/\A(?:\p{Hiragana}|[ー－]|[a-zA-Z0-9０-９])+\z/).blank?
        false
      else
        true
      end
    end
  end
end
