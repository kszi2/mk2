source "https://rubygems.org"

ruby "4.0.1"

gem "rack", "~> 3.2.2"
# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.1.2"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# gem "falcon", "~> 0.48.3"
gem "thruster", require: false

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
# gem "jsbundling-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ]

  # Parallel tests
  gem 'parallel_tests'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # profiling
  gem "rack-mini-profiler"
  gem "memory_profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  gem "spring"

  # error pages
  # gem "better_errors"

  # react to file changes
  gem "listen"
  gem "actioncable"
  gem "wdm", platform: %i[windows]

  # UI debug
  gem "lookbook", ">= 2.3.4"
end

group :test do
  # Coverage
  gem 'simplecov', require: false

  # Mocking
  gem "mocha"

  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
end

# UI rendering logic (HAML markup, and view components)
gem "haml", "~> 6.3"
gem "haml-rails", "~> 2.1"
gem "view_component"

# PDF generation
gem "ttfunk", "< 1.8.0"
gem "prawn-rails", "~> 1.6.0"

# HTTP requests
gem 'faraday'
gem 'faraday-multipart'
gem 'httpx'

gem "good_job", "~> 4.2"

# Pagination
gem "kaminari", "~> 1.2"

gem "rack-pratchett", "~> 0.1.1"

# Tooling
gem "foreman", "~> 0.88.1"

# S3 API
gem "aws-sdk-s3", "~> 1.175", require: false

# API docs
gem "apipie-rails", "~> 1.4"

# Custom non-integer id encoding format
gem "crockford32", "~> 1.1"

# image processing...
gem "image_processing", "~> 1.13"

# User management
gem "devise", "~> 4.9"
gem "devise-argon2", "~> 2.0"
gem "pundit", "~> 2.4"

gem "sxp", "~> 2.0"

gem "csv", "~> 3.3"

gem "active_record_union", "~> 1.4"
