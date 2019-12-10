require_relative 'boot'

# require 'rails/all'
require "rails"  
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Teppan
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.generators do |generator|
      generator.orm :active_record, primary_key_type: :integer
      generator.test_framework :rspec,
      # fixtures: false,
      view_specs: false,
      helper_specs: false,
      routing_specs: false
      generator.stylesheets     false
      generator.javascripts     false
      generator.helper          false
      generator.channel         assets: false
    end
    
    # 日本語化
    config.i18n.default_locale = :ja
    
    # 日本時間
    config.time_zone = 'Tokyo'
  end
end
