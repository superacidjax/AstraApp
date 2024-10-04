require "test_helper"
require "minitest/mock"

class PersonProcessorJobTest < ActiveJob::TestCase
  setup do
    @client_application = Fabricate(:client_application)
    @person_data = {
      client_user_id: "0192336a-e2b0-7eac-a76b-45f42c34089d",
      traits: {
        "firstName" => "John",
        "lastName" => "Doe",
        "email" => "john.doe@example.com",
        "current_bmi" => "22.5"
      },
      client_timestamp: "2023-10-25T23:48:46+00:00",
      application_id: @client_application.id
    }
  end

  test "should enqueue job" do
    assert_difference -> { GoodJob::Execution.count }, 1 do
      PersonProcessorJob.perform_later(@person_data)
    end
  end

  test "should call PersonProcessor service when performed" do
    PersonProcessorMock = Minitest::Mock.new
    PersonProcessorMock.expect(:call, true, [ @person_data ])

    PersonProcessor.stub :call, PersonProcessorMock do
      perform_enqueued_jobs do
        PersonProcessorJob.perform_later(@person_data)
      end
    end

    PersonProcessorMock.verify
  end
end
