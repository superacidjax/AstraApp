Fabricator(:person_rule, from: :rule) do
  name { Faker::Company.bs }
  type { "PersonRule" }
  ruleable { Fabricate(:trait) }

  after_build do |person_rule|
    value_type = person_rule.ruleable.value_type

    allowed_operators =
      case value_type
      when "numeric"
        [ "Greater than", "Less than", "Equal to", "Within range" ]
      when "text"
        [ "Equals", "Not equals", "Contains", "Does not contain" ]
      when "boolean"
        [ "Is", "Is not" ]
      when "datetime"
        [ "Before", "After", "Within range" ]
      else
        []
      end

    person_rule.operator = allowed_operators.sample

    if person_rule.operator == "Within range"
      person_rule.from = Faker::Number.between(from: 10, to: 50).to_s
      person_rule.to = Faker::Number.between(from: 51, to: 100).to_s
      person_rule.inclusive = Faker::Boolean.boolean
    else
      person_rule.value =
        case value_type
        when "numeric"
          Faker::Number.between(from: 1, to: 100).to_s
        when "text"
          Faker::Lorem.word
        when "boolean"
          Faker::Boolean.boolean.to_s
        when "datetime"
          Faker::Time.backward(days: 365).iso8601
        else
          nil
        end
    end
  end
end
