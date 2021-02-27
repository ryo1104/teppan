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
      # 全角ひらがな
      if str.match(/\A[ぁ-んー－]+\z/)
        true
      else
        false
      end
    end
  end
end
