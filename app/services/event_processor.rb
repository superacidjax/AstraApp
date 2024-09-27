class EventProcessor
  extend TypeInference

  def self.call(event_data)
    raise ArgumentError, "Missing required parameters: client_user_id" if event_data[:client_user_id].blank?

    event = Event.find_or_create_by!(
      name: event_data[:name],
      client_timestamp: event_data[:client_timestamp].to_time,
      client_user_id: event_data[:client_user_id]
    ) do |e|
      e.account_id = ClientApplication.find(event_data[:application_id]).account_id
    end

    event_data[:properties].each do |property_name, property_value|
      inferred_type = infer_type(property_value)

      property = Property.find_or_create_by!(
        name: property_name,
        account_id: event.account_id,
        value_type: inferred_type
      )
      property.client_applications << ClientApplication.find(event_data[:application_id])

      property_value = PropertyValue.create!(property_id: property.id, event_id: event.id, data: property_value)
    end
  end
end
