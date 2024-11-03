require "simplecov"
SimpleCov.start "rails"

ENV["RAILS_ENV"] ||= "test"
Dir[File.expand_path("support/**/*.rb", __dir__)].each { |file| require file }
require_relative "../config/environment"
require "rails/test_help"
require "view_component/test_case"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    parallelize_setup do |worker|
      SimpleCov.command_name "#{SimpleCov.command_name}-#{worker}"
    end

    parallelize_teardown do |worker|
      SimpleCov.result
    end

    # Add more helper methods to be used by all tests here...
  end
end
