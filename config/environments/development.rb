Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = true

  # Show full error reports.
  config.consider_all_requests_local = false

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :amazon

  # Don't care if the mailer can't send.
  config.action_mailer.default_url_options = { protocol: 'https', host: 'https://3c355ca7c62a41d683a0526b64642f45.vfs.cloud9.ap-southeast-1.amazonaws.com/' }
  config.action_mailer.perform_caching = false
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    port: 587,
    address: 'smtp.gmail.com',
    domain: 'gmail.com',
    user_name: ENV['GMAIL_USER_NAME'],
    password: ENV['GMAIL_USER_PASSWORD'],
    authentication: 'login',
    enable_starttls_auto: true
  }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  # config.assets.debug = true

  # Suppress logger output for asset requests.
  # config.assets.quiet = true

  # Raises error for missing translations.
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  config.web_console.whitelisted_ips = ['3.18.12.63', '3.130.192.231', '13.235.14.237', '13.235.122.149', '35.154.171.200',
                                        '52.15.183.38', '54.187.174.169', '54.187.205.235', '54.187.216.72', '54.241.31.99',
                                        '54.241.31.102', '54.241.34.107', '202.32.34.208']
  config.hosts = [
    IPAddr.new('0.0.0.0/0'), # All IPv4 addresses.
    IPAddr.new('::/0'),      # All IPv6 addresses.
    'localhost',             # The localhost reserved domain.
    '3c355ca7c62a41d683a0526b64642f45.vfs.cloud9.ap-southeast-1.amazonaws.com',
    'ec2-52-77-251-96.ap-southeast-1.compute.amazonaws.com'
  ]

  # config.after_initialize do
  #   Bullet.enable = true
  #   Bullet.alert = true
  #   Bullet.bullet_logger = true
  #   Bullet.console = true
  #   Bullet.rails_logger = true
  # end
  
  # Disables log coloration
  config.colorize_logging = false  
  
  config.log_formatter = proc do |severity, datetime, progname, msg|
    "[#{severity}] #{datetime}: #{progname} : #{msg}\n"
  end
end
