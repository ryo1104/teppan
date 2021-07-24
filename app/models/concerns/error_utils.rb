# frozen_string_literal: true

module ErrorUtils
  extend ActiveSupport::Concern

  class ErrorUtility
    def self.log_and_notify(exc: nil, data: {})
      if exc.present?
        ExceptionNotifier.notify_exception(exc, data: data)
        Rails.logger.error "#{exc.class} / #{exc.message}"
        Rails.logger.error exc.backtrace.join("\n")
        Rails.logger.error "data : #{data}"
      end
    end
  end

  # this will be rescued by Rambulance
  class AccessDeniedError < StandardError; end
end
