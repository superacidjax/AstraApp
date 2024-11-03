import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["rulesContainer", "ruleGroupContainer", "template"]

  connect() {
    // Initialize if needed
  }

  addRule(event) {
    event.preventDefault()
    const newId = new Date().getTime()
    const template = this.templateTarget.innerHTML.replace(/TEMPLATE_ID/g, newId)
    this.rulesContainerTarget.insertAdjacentHTML('beforeend', template)
  }

  addRuleGroup(event) {
    event.preventDefault()
    const newId = new Date().getTime()
    const template = this.templateTarget.innerHTML.replace(/TEMPLATE_ID/g, newId)
    this.ruleGroupContainerTarget.insertAdjacentHTML('beforeend', template)
  }

  removeField(event) {
    event.preventDefault()
    const field = event.target.closest('.nested-fields')
    field.remove()
  }
