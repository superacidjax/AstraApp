Fabricator(:person_rule, from: :rule) do
  name { Faker::Company.bs }
  type { "PersonRule" }
  ruleable { Fabricate(:trait) }

  after_build do |person_rule|
    value_type = person_rule.ruleable.value_type

    allowed_operators =
      case value_type
      when "numeric"
        [ "greater_than", "less_than", "equal_to", "within_range" ]
      when "text"
        [ "equals", "not_equals", "contains", "does_not_contain" ]
      when "boolean"
        [ "is", "is_not" ]
      when "datetime"
        [ "before", "after", "within_range" ]
      else
        []
      end

    person_rule.operator = allowed_operators.sample

    if person_rule.operator == "within_range"
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
