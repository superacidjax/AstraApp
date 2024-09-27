class PersonProcessorJob < ApplicationJob
  queue_as :default

  def perform(person_data)
    PersonProcessor.call(person_data)
  end
end
