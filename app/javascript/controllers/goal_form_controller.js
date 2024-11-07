// app/javascript/controllers/goal_form_controller.js
import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="goal-form"
export default class extends Controller {
  static targets = ["rulesContainer", "template"]

  connect() {
    // Initialization logic if needed
  }

  /**
   * Adds a new Rule Group by cloning the template and inserting it into the rules container.
   */
  addRuleGroup(event) {
    event.preventDefault()
    const newId = new Date().getTime()
    const template = this.templateTarget.querySelector("#rule-group-template").innerHTML.replace(/TEMPLATE_ID/g, newId)
    this.rulesContainerTarget.insertAdjacentHTML('beforeend', template)
  }

  /**
   * Adds a new Rule by cloning the template and inserting it into the appropriate rules container.
   */
  addRule(event) {
    event.preventDefault()
    const newId = new Date().getTime()
    const template = this.templateTarget.querySelector("#rule-template").innerHTML.replace(/TEMPLATE_ID/g, newId)
    this.rulesContainerTarget.insertAdjacentHTML('beforeend', template)
  }

  /**
   * Adds a nested Rule Group within an existing Rule Group.
   */
  addNestedRuleGroup(event) {
    event.preventDefault()
    const parentRuleGroup = event.target.closest(".rule-group")
    const nestedRulesContainer = parentRuleGroup.querySelector(".rules")
    const newId = new Date().getTime()
    const template = this.templateTarget.querySelector("#rule-group-template").innerHTML.replace(/TEMPLATE_ID/g, newId)
    nestedRulesContainer.insertAdjacentHTML('beforeend', template)
  }

  /**
   * Removes a field (Rule or Rule Group) from the form.
   */
  removeField(event) {
    event.preventDefault()
    const field = event.target.closest(".rule, .rule-group")
    if (field) {
      field.remove()
    }
  }
}
