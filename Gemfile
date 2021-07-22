# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.1'
# Use mysql as the database for Active Record
gem 'mysql2'
# Use Puma as the app server
# gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
# gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
# gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem 'actiontext'
gem 'trix'
# Use Active Storage variant
gem 'image_processing', '~> 1.2'
gem 'mini_magick', '~> 4.10'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails' # , '~> 5.0.2'
  gem 'pry-rails'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen'
  gem 'web-console'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'bullet'
  gem 'rails-erd'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen'
  gem 'unicode-display_width', '>= 1.4.0'
end

group :test do
  gem 'capybara'
  gem 'faker'
  gem 'fakes3', '0.2.5' # latest fakes3 version is not free.
  gem 'glint'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'devise'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'kaminari'
gem 'material_icons'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'
gem 'omniauth-twitter'
gem 'omniauth-yahoojp'
gem 'paperclip'
gem 'rails-i18n'
gem 'ransack'

# breadcrumbs
gem 'gretel'

# 課金サービス
gem 'stripe'
gem 'zengin_code', require: false

# カウンター
gem 'counter_culture', '~> 1.0'

# Amazon S3
gem 'aws-sdk-s3'

# Error pages
gem 'rambulance'

# 読み仮名
gem 'rubyfuri'

# Serializer
gem 'fast_jsonapi'

# Phone number
gem 'telephone_number'

# 環境変数
gem 'dotenv-rails'
