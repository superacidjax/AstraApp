require "test_helper"
require "minitest/mock"

class EventProcessorJobTest < ActiveJob::TestCase
  setup do
    @client_application = Fabricate(:client_application)
    @event_data = {
      client_user_id: "0191faa2-b4d7-78bc-8cdc-6a4dc176ebb4",
      name: "New sign up",
      properties: {
        "subscription_type" => "premium",
        "subscription_value" => "930"
      },
      client_timestamp: "2023-10-25T23:48:46+00:00",
      application_id: @client_application.id
    }
  end

  test "should enqueue job" do
    assert_difference -> { GoodJob::Execution.count }, 1 do
      EventProcessorJob.perform_later(@event_data)
    end
  end

  test "should call EventProcessor service when performed" do
    EventProcessorMock = Minitest::Mock.new
    EventProcessorMock.expect(:call, true, [ @event_data ])

    EventProcessor.stub :call, EventProcessorMock do
      perform_enqueued_jobs do
        EventProcessorJob.perform_later(@event_data)
      end
    end

    EventProcessorMock.verify
  end
end
