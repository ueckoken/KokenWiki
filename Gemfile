source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "~> 3.3.0"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 6.1.7"
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
# gem 'pg'
# Use Puma as the app server
gem "puma", "~> 4.3"
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.5"
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
gem "bcrypt", "~> 3.1.7"

gem "base64", "~> 0.2.0"
gem "bigdecimal", "~> 3.1.9"
gem "mutex_m", "~> 0.3.0"
gem 'concurrent-ruby', '1.3.4'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.16.0", require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console", ">= 3.3.0"
  gem "listen", ">= 3.8.0"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "pry", "~> 0.15.2"
  gem "pry-byebug"

  gem "rubocop", "~> 1.8.0"
  gem "rubocop-rails", "~> 2.9.1"
  gem "rubocop-performance", "~> 1.9.2"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 2.15"
  gem "selenium-webdriver"
  gem "webdrivers"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# gem "actionpack-action_caching"
gem "jsbundling-rails"

gem "devise", "~> 4.9.0"
gem "devise-bootstrap-views"

gem "cancancan", ">= 3.2.1"

gem "google-cloud-storage", "~> 1.44.0", require: false

gem "mysql2", "~> 0.5.3"

gem "appengine", "~> 0.5.0"

gem "octicons_helper", "~> 10.0"

gem "commonmarker", "~> 0.23.4"

gem "rails-i18n", "~> 6.0"
gem "devise-i18n"

gem "webrick", "~> 1.9"
