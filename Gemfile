source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.2.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1', '>= 3.1.11'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'
gem 'bootsnap'
# Exception Notifier Plugin for Rails
gem 'exception_notification'
# ActiveModel::Serializer implementation and Rails hooks
gem 'active_model_serializers', '~> 0.10.0'
# Classier solution for file uploads for Rails, Sinatra and other Ruby web frameworks
gem 'carrierwave', '~> 1.0'
gem 'carrierwave-base64'
# Flexible authentication solution for Rails with Warden.
gem 'devise', '~> 4.4', '>= 4.4.3'
# An invitation strategy for devise
gem 'devise_invitable', '~> 1.7', '>= 1.7.4'
# JWT token authentication with devise and rails
gem 'devise-jwt', '~> 0.5.3'
# Seamlessly adds a Swagger to Rails-based API's
gem 'rswag', '2.0.6'
# RSpec for Rails-3+ http://relishapp.com/rspec/rspec-rails
gem 'rspec-rails', '~> 3.6'
# Pagination
gem 'kaminari', '~> 1.1', '>= 1.1.1'
# SlackAPI
gem 'slack-ruby-bot', '~> 0.11.0'
# Image processor
gem 'mini_magick'
# Updates cron tasks
gem 'whenever', require: false
# Background processing
gem 'sidekiq', '~> 5.1', '>= 5.1.1'
# ActiveJob::Cancel
gem 'activejob-cancel', '~> 0.3.0'
# Object oriented authorization for Rails applications
gem 'pundit'
# Client for TimeDoctor API
gem 'timedoctor', '~> 0.3.2'
# ActiveRecord plugin allowing you to hide and restore records without actually deleting them.
gem 'paranoia', '~> 2.2'
# Discord API
gem 'discordrb', '~> 3.2', '>= 3.2.1'
# Raven is a Ruby client for Sentry https://getsentry.com
gem 'sentry-raven'
#A collection of Ruby methods to deal with statutory and other holidays. You deserve a holiday!
gem 'holidays'
#Faraday is an HTTP client library that provides a common interface over many adapters
gem 'faraday'
#Support for doing time math in business hours and days
gem 'business_time'
#Liquid markup language. Safe, customer facing template language for flexible web apps.
gem 'liquid'
gem 'rbnacl-libsodium'
gem 'pretender'
# Pretty print your Ruby objects with style -- in full color and with proper indentation
gem 'awesome_print', '~> 1.8'
# https://github.com/thoughtbot/factory_bot
gem 'factory_bot_rails', '~> 4.8', '>= 4.8.2'
# A library for generating fake data such as names, addresses, and phone numbers.
gem 'faker'
gem 'nokogiri', '1.10.9'

group :development, :test do
  # Pry
  gem 'pry', '~> 0.11.3'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Collection of testing matchers extracted from Shoulda
  gem 'shoulda-matchers', '~> 3.1'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 2.0', '>= 2.0.2'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # A Ruby static code analyzer, based on the community Ruby style guide. http://rubocop.readthedocs.io
  gem 'rubocop', '~> 0.58.2', require: false
  gem 'rubocop-rspec'
  # A static analysis security vulnerability scanner for Ruby on Rails applications
  gem 'brakeman', '~> 4.7.0', require: false
  # Guard::Bundler automatically install/update your gem bundle when needed https://rubygems.org/gems/guard-bundler
  gem 'guard-bundler', '~> 2.1', require: false
  # Guard::RSpec automatically run your specs (much like autotest) https://rubygems.org/gems/guard-rspec
  gem 'guard-rspec', '~> 4.7', '>= 4.7.3', require: false
  # Guard plugin for RuboCop
  gem 'guard-rubocop', '~> 1.3', require: false
  # Annotate Rails classes with schema and routes info
  gem 'annotate', '~> 2.7', '>= 2.7.2'
  # Preview mail in the browser instead of sending.
  gem 'letter_opener', '~> 1.6'
  # Guard::Shell automatically run shell commands when watched files are modified.
  gem 'guard-shell', '~> 0.7.1', require: false

  # For deploy we use capistrano and helper gems
  gem 'capistrano', '~> 3.10', require: false
  gem 'capistrano-rails', '~> 1.4', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano3-puma', require: false
  gem 'capistrano3-nginx', '~> 2.0', require: false
  gem 'capistrano-rails-console', require: false
  gem "capistrano-db-tasks", require: false
end

group :test do
  # Code coverage for Ruby 1.9+ with a powerful configuration library and automatic merging of coverage across test suites
  gem 'simplecov', '~> 0.16.1', :require => false
  # Strategies for cleaning databases in Ruby. Can be used to ensure a clean state for testing.
  gem 'database_cleaner', '~> 1.6', '>= 1.6.2'
  # RSpec results formatted as JUnit XML that your CI can read
  gem 'rspec_junit_formatter', '~> 0.3.0'
  # Library for stubbing and setting expectations on HTTP requests in Ruby.
  gem 'webmock', '~> 3.3'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
