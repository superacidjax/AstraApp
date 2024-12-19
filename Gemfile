source "https://rubygems.org"

ruby "3.3.6"
gem "rails", "~> 8.0.1"

gem "activerecord-import"
gem "activeresource"
gem "bootsnap", require: false
gem "bulma-rails"
gem "dartsass-rails"
gem "good_job"
gem "importmap-rails"
gem "jsonb_accessor"
gem "ostruct"
gem "pg"
gem "propshaft"
gem "puma"
gem "stimulus-rails"
gem "turbo-rails"
gem "uuid7"
gem "view_component"

group :development, :test do
  gem "brakeman", require: false
  gem "pry-rails"
  gem "rubocop-rails-omakase", require: false
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

group :production do
  gem "sentry-rails"
  gem "sentry-ruby"
  gem "stackprof"
end
