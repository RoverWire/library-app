# frozen_string_literal: true

source 'https://rubygems.org'

ruby file: '.ruby-version'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 8.1.3'
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem 'propshaft'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'

# Devise is a flexible authentication solution for Rails based on Warden. (https://github.com/heartcombo/devise)
gem 'devise'
# Devise JWT Extension for JWT token generation and verification. (https://github.com/heartcombo/devise-jwt)
gem 'devise-jwt'
# CanCanCan is an authorization library for Ruby on Rails which restricts what resources a given user is allowed to access. (https://github.com/cancancommunity/cancancan)
gem 'cancancan'
# Use Vite in Rails and bring joy to your JavaScript experience (https://github.com/ElMassimo/vite_ruby)
# gem 'vite_rails'
# Tame Rails' multi-line logging into a single line per request (https://github.com/roidrage/lograge)
gem 'lograge'
# Middleware for enabling Cross-Origin Resource Sharing in Rack apps (https://github.com/cyu/rack-cors)
gem 'rack-cors', require: 'rack/cors'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

group :development, :test do
  # Security vulnerability scanner for Ruby on Rails. (https://brakemanscanner.org)
  gem 'brakeman', require: false
  # Patch-level verification for Bundler (https://github.com/rubysec/bundler-audit)
  gem 'bundler-audit', require: false
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
  # Loads environment variables from `.env`. (https://github.com/bkeepers/dotenv)
  gem 'dotenv'
  # Fixture replacement with a straightforward definition syntax. (https://github.com/thoughtbot/factory_bot_rails
  gem 'factory_bot_rails'
  # Random data generator for testing and database population (https://github.com/faker-ruby/faker)
  gem 'faker'
  # Pry is a powerful alternative to the standard IRB shell for Ruby. (https://github.com/pry/pry-rails)
  gem 'pry-rails'
  # RSpec for Rails (https://github.com/rspec/rspec-rails)
  gem 'rspec-rails'
  # Automatic Ruby code style checking tool. (https://github.com/rubocop/rubocop)
  gem 'rubocop', require: false
  # Automatic performance checking tool for Ruby code. (https://github.com/rubocop/rubocop-performance)
  gem 'rubocop-performance', require: false
  # Automatic Rails code style checking tool. (https://github.com/rubocop/rubocop-rails)
  gem 'rubocop-rails', require: false
  # Code style checking for RSpec files (https://github.com/rubocop/rubocop-rspec)
  gem 'rubocop-rspec', require: false
  # Code style checking for factory_bot files (https://github.com/rubocop/rubocop-factory_bot)
  gem 'rubocop-factory_bot', require: false
  # Code style checking for RSpec Rails files (https://github.com/rubocop/rubocop-rspec_rails)
  gem 'rubocop-rspec_rails', require: false
end

group :development do
  # A gem for generating annotations for Rails projects. (https://github.com/drwl/annotaterb)
  gem 'annotaterb'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code. (https://github.com/rails/web-console)
  gem 'web-console', '>= 4.1.0'
  # prettier plugin for the Ruby programming language (https://github.com/prettier/plugin-ruby#readme)
  gem 'prettier'
end

group :test do
  # Set of gems containing strategies for cleaning your database in Ruby. (https://github.com/DatabaseCleaner/database_cleaner)
  gem 'database_cleaner-active_record'
  # Provides RSpec and Minitest-compatible one-liners to test common Rails functionality (https://github.com/thoughtbot/shoulda-matchers)
  gem 'shoulda-matchers', '~> 7.0'
end
