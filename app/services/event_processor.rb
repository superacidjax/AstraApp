class EventProcessor
  extend TypeInference

  def self.call(event_data)
    validate_event_data!(event_data)
    event = create_event(event_data)
    client_application = find_client_application(event_data[:application_id])
    process_properties(event, event_data[:properties], client_application)
  end

  private

  def self.validate_event_data!(event_data)
    raise ArgumentError, "Missing required parameters: client_user_id" if event_data[:client_user_id].blank?
    raise ArgumentError, "Missing required parameters: properties" if event_data[:properties].blank?
    raise ArgumentError, "Missing required parameters: application_id" if event_data[:application_id].blank?
  end

  def self.create_event(event_data)
    Event.create!(
      name: event_data[:name],
      client_timestamp: event_data[:client_timestamp].to_time,
      client_user_id: event_data[:client_user_id],
      client_application_id: event_data[:application_id]
    )
  end

  def self.find_client_application(application_id)
    ClientApplication.find(application_id)
  end

  def self.process_properties(event, properties_data, client_application)
    account_id = client_application.account_id

    # Preload existing properties
    property_names = properties_data.keys
    existing_properties = preload_existing_properties(property_names, account_id)

    property_values = []

    properties_data.each do |property_name, property_value|
      inferred_type = infer_type(property_value)

      # Get existing property or build a new one
      property = existing_properties[property_name] || Property.new(
        name: property_name,
        account_id: account_id,
        value_type: inferred_type
      )

      if property.new_record?
        property.save!
        existing_properties[property_name] = property
      end

      # Prepare property values for bulk insert
      property_values << build_property_value(property, event, property_value)
    end

    # Insert property values
    insert_property_values(property_values)
  end

  def self.preload_existing_properties(property_names, account_id)
    Property.where(name: property_names, account_id: account_id).index_by(&:name)
  end

  def self.build_property_value(property, event, property_value)
    {
      property_id: property.id,
      event_id: event.id,
      data: property_value,
      created_at: Time.now,
      updated_at: Time.now
    }
  end

  def self.insert_property_values(property_values)
    PropertyValue.insert_all!(property_values) unless property_values.empty?
  end
end
