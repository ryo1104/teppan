# frozen_string_literal: true

module ErrorUtils
  extend ActiveSupport::Concern

  class ErrorUtility
    def self.log_and_notify(exc)
      Rails.logger.error "#{exc.class} / #{exc.message}"
      Rails.logger.error exc.backtrace.join("\n")
    end
  end

  # this will be rescued by Rambulance
  class AccessDeniedError < StandardError; end
end
