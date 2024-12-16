import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "peopleTabLink",
    "eventTabLink",
    "peopleTabContent",
    "eventTabContent",
    "clientApplications"
  ]

  connect() {
    console.log("rule builder controller connected")
  }

  selectRuleType(event) {
    event.preventDefault()
    const type = event.currentTarget.dataset.ruleTypeValue

    // Toggle tab link active states
    this.peopleTabLinkTarget.classList.toggle("is-active", type === "person_rule")
    this.eventTabLinkTarget.classList.toggle("is-active", type === "event_rule")

    // Toggle content visibility
    this.peopleTabContentTarget.classList.toggle("is-hidden", type !== "person_rule")
    this.eventTabContentTarget.classList.toggle("is-hidden", type !== "event_rule")
  }

  addRule(event) {
    event.preventDefault()
    // Logic for adding a rule if implemented in the future
  }
}
