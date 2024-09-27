class EventProcessorJob < ApplicationJob
  queue_as :default

  def perform(event_data)
    EventProcessor.call(event_data)
  end
end
