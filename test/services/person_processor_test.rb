require "test_helper"

class PersonProcessorTest < ActiveSupport::TestCase
  setup do
    @person_data = {
      user_id: "0191faa2-b4d7-78bc-8cdc-6a4dc176ebb4",
      traits: {
        "firstName" => "Brian",
        "lastName" => "Dear",
        "email" => "brian@example.com",
        "current_bmi" => "21"
      },
      timestamp: "2023-10-25T23:48:46+00:00",
      application_id: client_applications(:one).id
    }
  end

  test "should create a person with traits and trait values" do
    assert_difference -> { Person.count }, 1 do
      assert_difference -> { Trait.count }, 4 do
        assert_difference -> { TraitValue.count }, 4 do
          PersonProcessor.call(@person_data)
        end
      end
    end

    person = Person.find_by(client_user_id: @person_data[:user_id])
    assert person.present?, "Person should be created"
    # Check traits
    traits = person.traits
    assert_equal 4, traits.count
    assert_includes traits.map(&:name), "firstName"
    assert_includes traits.map(&:name), "current_bmi"

    # Check trait values
    trait_value = TraitValue.find_by(person_id: person.id, trait_id: traits.find_by(name: "firstName").id)
    assert_equal "Brian", trait_value.data
  end

  test "should infer the correct types for traits" do
    PersonProcessor.call(@person_data)

    first_name_trait = Trait.find_by(name: "firstName")
    current_bmi_trait = Trait.find_by(name: "current_bmi")

    assert_equal "text", first_name_trait.value_type
    assert_equal "numeric", current_bmi_trait.value_type
  end

  test "should raise an error for missing user_id" do
    @person_data.delete(:user_id)

    assert_no_difference -> { Person.count } do
      assert_raises(ArgumentError, "Missing required parameters: user_id") do
        PersonProcessor.call(@person_data)
      end
    end
  end

  test "should not create traits if application_id is missing" do
    @person_data.delete(:application_id)

    assert_no_difference -> { Trait.count } do
      assert_raises(ActiveRecord::RecordNotFound) do
        PersonProcessor.call(@person_data)
      end
    end
  end
end
