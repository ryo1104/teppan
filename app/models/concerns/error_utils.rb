module ErrorUtils
  extend ActiveSupport::Concern

  class ErrorUtility
    def self.log_and_notify(e)
      Rails.logger.error "#{e.class} / #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
    end
  end
  
  # this will be rescued by Rambulance
  class AccessDeniedError < StandardError; end
  
end
