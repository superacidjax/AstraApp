source "https://rubygems.org"

ruby "3.3.5"

gem "rails", "~> 7.2.1"
gem "sprockets-rails"
gem "pg", "~> 1.5"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "jsonb_accessor"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "redis", ">= 4.0.1"
gem "bootsnap", require: false
gem "activeresource"
gem "uuid7"
gem "ostruct"
gem "good_job"
gem "activerecord-import"
gem "view_components"

group :development, :test do
  gem "pry-rails"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :production do
  gem "stackprof"
  gem "sentry-ruby"
  gem "sentry-rails"
end

group :development do
  gem "rails-erd"
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "fabrication"
  gem "faker"
  gem "selenium-webdriver"
  gem "simplecov", require: false
  gem "webmock"
end
