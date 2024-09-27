class PersonProcessor
  extend TypeInference

  def self.call(person_data)
    raise ArgumentError, "Missing required parameters: client_user_id" if person_data[:client_user_id].blank?

    person = Person.find_or_create_by(
      client_user_id: person_data[:client_user_id]
    ) do |p|
      p.client_timestamp = person_data[:client_timestamp]
      p.account_id = ClientApplication.find(person_data[:application_id]).account_id
    end

    person_data[:traits].each do |trait|
      new_trait = Trait.find_or_create_by(
        name: trait[0],
        account_id: person.account_id,
        value_type: infer_type(trait[1])
      )
      new_trait.client_applications << ClientApplication.find(person_data[:application_id])
      TraitValue.create!(trait_id: new_trait.id, person_id: person.id, data: trait[1])
    end
  end
end
