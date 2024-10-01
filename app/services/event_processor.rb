class EventProcessor
  extend TypeInference

  def self.call(event_data)
    raise ArgumentError, "Missing required parameters: client_user_id" if event_data[:client_user_id].blank?
    raise ArgumentError, "Missing required parameters: properties" if event_data[:properties].blank?
    raise ArgumentError, "Missing required parameters: application_id" if event_data[:application_id].blank?

    # Create the event
    event = Event.create!(
      name: event_data[:name],
      client_timestamp: event_data[:client_timestamp].to_time,
      client_user_id: event_data[:client_user_id],
      client_application_id: event_data[:application_id]
    )

    client_application = ClientApplication.find(event_data[:application_id])
    account_id = client_application.account_id

    # Preload all properties to minimize database queries
    property_names = event_data[:properties].keys
    existing_properties = Property.where(name: property_names, account_id: account_id).index_by(&:name)

    new_properties = []
    property_values = []

    event_data[:properties].each do |property_name, property_value|
      inferred_type = infer_type(property_value)

      # Find or build property in memory to reduce DB calls
      property = existing_properties[property_name] || Property.new(
        name: property_name,
        account_id: account_id,
        value_type: inferred_type
      )

      # Only add the property to new_properties if it's a new record
      if property.new_record?
        new_properties << property
        existing_properties[property_name] = property
      end
    end

    # Save all new properties to get their IDs
    Property.import(new_properties) unless new_properties.empty?

    # Reload new_properties to ensure we have IDs after import
    if new_properties.any?
      saved_properties = Property.where(id: new_properties.map(&:id)).index_by(&:name)
      existing_properties.merge!(saved_properties)
    end

    # Prepare property value data for bulk insertion
    event_data[:properties].each do |property_name, property_value|
      property = existing_properties[property_name]

      property_values << {
        property_id: property.id,
        event_id: event.id,
        data: property_value,
        created_at: Time.now,
        updated_at: Time.now
      }
    end

    # Bulk insert property values
    PropertyValue.insert_all(property_values)

    # Ensure property-client_application relationship exists, avoid N+1 queries
    new_properties.each do |property|
      property.client_applications << client_application unless property.client_applications.include?(client_application)
    end
  end
end
