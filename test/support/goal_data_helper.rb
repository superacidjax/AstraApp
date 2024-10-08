module GoalDataHelper
  def valid_goal_data(trait_text:, trait_numeric:, trait_boolean:, property_numeric:, property_datetime:)
    {
      "initial_state" => {
        "items" => [
          {
            "type" => "rule_group",
            "name" => "Group 1",
            "operator" => "AND",
            "items" => [
              {
                "type" => "rule_group",
                "name" => "Group 1.1",
                "operator" => "OR",
                "items" => [
                  {
                    "type" => "rule",
                    "name" => "Rule 1",
                    "data" => { "trait_operator" => "Equals", "trait_value" => "some value" },
                    "ruleable" => { "type" => "trait", "value_type" => "text", "id" => trait_text.id },
                    "operator" => "AND"
                  },
                  {
                    "type" => "rule",
                    "name" => "Rule 2",
                    "data" => { "property_operator" => "Greater than", "property_value" => "100" },
                    "ruleable" => { "type" => "property", "value_type" => "numeric", "id" => property_numeric.id },
                    "operator" => nil
                  }
                ]
              },
              {
                "type" => "rule_group",
                "name" => "Group 1.2",
                "items" => [
                  {
                    "type" => "rule",
                    "name" => "Rule 3",
                    "data" => { "trait_operator" => "Contains", "trait_value" => "keyword" },
                    "ruleable" => { "type" => "trait", "value_type" => "text", "id" => trait_text.id },
                    "operator" => "OR"
                  },
                  {
                    "type" => "rule",
                    "name" => "Rule 4",
                    "data" => { "property_operator" => "Less than", "property_value" => "50" },
                    "ruleable" => { "type" => "property", "value_type" => "numeric", "id" => property_numeric.id },
                    "operator" => nil
                  }
                ]
              }
            ]
          },
          {
            "type" => "rule",
            "name" => "Rule 5",
            "data" => { "trait_operator" => "Is", "trait_value" => "true" },
            "ruleable" => { "type" => "trait", "value_type" => "boolean", "id" => trait_boolean.id },
            "operator" => nil
          }
        ]
      },
      "end_state" => {
        "items" => [
          {
            "type" => "rule_group",
            "name" => "Group 2",
            "operator" => "OR",
            "items" => [
              {
                "type" => "rule",
                "name" => "Rule 6",
                "data" => { "property_operator" => "Within range", "property_from" => "20", "property_to" => "100", "property_inclusive" => true },
                "ruleable" => { "type" => "property", "value_type" => "numeric", "id" => property_numeric.id },
                "operator" => "OR"
              },
              {
                "type" => "rule_group",
                "name" => "Group 2.1",
                "items" => [
                  {
                    "type" => "rule",
                    "name" => "Rule 7",
                    "data" => { "trait_operator" => "Greater than", "trait_value" => "5" },
                    "ruleable" => { "type" => "trait", "value_type" => "numeric", "id" => trait_numeric.id },
                    "operator" => "AND"
                  },
                  {
                    "type" => "rule",
                    "name" => "Rule 8",
                    "data" => { "property_operator" => "Before", "property_value" => "2024-01-01T00:00:00+00:00" },
                    "ruleable" => { "type" => "property", "value_type" => "datetime", "id" => property_datetime.id },
                    "operator" => nil
                  }
                ]
              }
            ]
          },
          {
            "type" => "rule_group",
            "name" => "Group 3",
            "items" => [
              {
                "type" => "rule",
                "name" => "Rule 9",
                "data" => { "trait_operator" => "Not equals", "trait_value" => "some other value" },
                "ruleable" => { "type" => "trait", "value_type" => "text", "id" => trait_text.id },
                "operator" => "OR"
              },
              {
                "type" => "rule_group",
                "name" => "Group 3.1",
                "operator" => nil,
                "items" => [
                  {
                    "type" => "rule",
                    "name" => "Rule 10",
                    "data" => { "trait_operator" => "Is not", "trait_value" => "false" },
                    "ruleable" => { "type" => "trait", "value_type" => "boolean", "id" => trait_boolean.id },
                    "operator" => "AND"
                  },
                  {
                    "type" => "rule",
                    "name" => "Rule 11",
                    "data" => { "property_operator" => "After", "property_value" => "2024-12-31T23:59:59+00:00" },
                    "ruleable" => { "type" => "property", "value_type" => "datetime", "id" => property_datetime.id },
                    "operator" => nil
                  }
                ]
              }
            ]
          }
        ]
      }
    }
  end
end
