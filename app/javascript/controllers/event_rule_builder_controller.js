import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "eventRuleFields",
    "eventSelector",
    "propertySelector"
    // plus additional targets for operator, textInputGroup, etc.
  ]

  connect() {
    // Initialization code
  }

  // Similar logic to people_rule_builder_controller.js
  // Load events, properties, update operator options based on value_type, etc.
}
