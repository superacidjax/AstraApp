source "https://rubygems.org"

ruby "3.3.5"
gem "rails", "~> 7.2.1"

gem "activerecord-import"
gem "bootsnap", require: false
gem "good_job"
gem "importmap-rails"
gem "jsonb_accessor"
gem "ostruct"
gem "pg", "~> 1.5"
gem "puma", ">= 5.0"
gem "redis", ">= 4.0.1"
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails"
gem "uuid7"
gem "view_component"

group :development, :test do
  gem "brakeman", require: false
  gem "fabrication"
  gem "pry-rails"
  gem "rubocop-rails-omakase", require: false
end

group :production do
  gem "sentry-rails"
  gem "sentry-ruby"
  gem "stackprof"
end

group :development do
  gem "rails-erd"
  gem "web-console"
end

group :test do
  gem "capybara"
  # gem "launchy"
  gem "rails-controller-testing"
  gem "selenium-webdriver"
  gem "simplecov", require: false
  gem "webmock"
end
