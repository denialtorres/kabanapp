source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.1"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
# Use postgres as the database for Active Record
gem "pg", "~> 1.1"

# for test
gem "sqlite3"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# cors middleware
gem "rack-cors"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false

  # debuggin
  gem "pry"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
  # Database diagram
  gem "rails-erd"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "shoulda-matchers", "~> 6.0"
  # for mock data
  gem "factory_bot"
  gem "rswag-specs"
  # clear database after each test
  gem "database_cleaner-active_record"

  # for mock calls
  gem "vcr"
  gem "webmock"
end

gem "rspec-rails", "~> 7.1", groups: [ :development, :test ]

gem "devise", "~> 4.9"
gem "devise-api", "~> 0.2.0"

# serialize api response
gem "jsonapi-serializer"

# bootstrap
gem "bootstrap"
gem "sassc-rails"

# user roles
gem "cancancan"

# background jobs
gem "sidekiq", "~> 7.3"

# cronjobs in redis/sidekiq
gem "sidekiq-cron"

# cursor pagination
gem "rotulus"

# env variables
gem "dotenv"

# interactor gem
gem "interactor"

# for queries
gem "ransack"

# to make external calls
gem "httparty"

# for cache
gem "redis", "~> 5.3.0"
gem "redis-client", "~> 0.23.0"
gem "fastentry"

gem "graphql", "~> 2.5"
gem "graphiql-rails"

# for api documentation
gem "rswag-api"
gem "rswag-ui"
