import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "traitSelector",
    "operatorSelector",
    "operatorGroup",
    "textInputGroup",
    "numericInputGroup",
    "numericRangeGroup",
    "booleanInputGroup",
    "datetimeInputGroup",
    "datetimeRangeGroup",
    "ruleFields"
  ]

  connect() {
    console.log("people rule builder connected")

    const traitsValue = this.element.dataset.peopleRuleBuilderTraitsValue
    this.allTraits = traitsValue ? JSON.parse(traitsValue) : []

    // Attach a handler to the nearest form's submit event
    const form = this.element.closest("form")
    if (form) {
      form.addEventListener("submit", () => this.cleanupFields())
    }
  }

  updateOperator(event) {
    const selectedTraitId = event.target.value
    const selectedTrait = this.allTraits.find(
      (trait) => trait.id.toString() === selectedTraitId
    )

    this.clearOperatorOptions()
    this.clearDynamicInputs()

    if (!selectedTrait) return

    this.selectedValueType = selectedTrait.value_type
    let operators = []

    switch (this.selectedValueType) {
      case "text":
        operators = ["Equals", "Not equals", "Contains", "Does not contain"]
        break
      case "numeric":
        operators = ["Greater than", "Less than", "Equal to", "Within range"]
        break
      case "boolean":
        operators = ["Is", "Is not"]
        break
      case "datetime":
        operators = ["Before", "After", "Within range"]
        break
      default:
        console.warn("Unknown value type:", this.selectedValueType)
    }

    operators.forEach((operator) => {
      const option = document.createElement("option")
      option.value = operator.toLowerCase().replace(/ /g, "_")
      option.textContent = operator
      this.operatorSelectorTarget.appendChild(option)
    })
  }

  clearOperatorOptions() {
    this.operatorSelectorTarget.innerHTML = ""
    const defaultOption = document.createElement("option")
    defaultOption.value = ""
    defaultOption.textContent = "Select an operator"
    this.operatorSelectorTarget.appendChild(defaultOption)
  }

  clearDynamicInputs() {
    const inputGroups = [
      "textInputGroup",
      "numericInputGroup",
      "numericRangeGroup",
      "booleanInputGroup",
      "datetimeInputGroup",
      "datetimeRangeGroup"
    ]
    inputGroups.forEach((group) => {
      const target = this[`${group}Target`]
      if (target) {
        target.style.display = "none"
      }
    })
  }

  handleOperatorChange(event) {
    const selectedOperator = event.target.value

    if (!this.selectedValueType) {
      const selectedTraitId = this.traitSelectorTarget.value
      const selectedTrait = this.allTraits.find(
        (trait) => trait.id.toString() === selectedTraitId
      )
      if (selectedTrait) {
        this.selectedValueType = selectedTrait.value_type
      } else {
        console.warn("No trait selected")
        return
      }
    }

    this.clearDynamicInputs()

    if (selectedOperator === "within_range") {
      if (this.selectedValueType === "numeric") {
        this.showOptionalTarget(this.numericRangeGroupTarget)
      } else if (this.selectedValueType === "datetime") {
        this.showOptionalTarget(this.datetimeRangeGroupTarget)
      }
    } else {
      switch (this.selectedValueType) {
        case "numeric":
          this.showOptionalTarget(this.numericInputGroupTarget)
          break
        case "datetime":
          this.showOptionalTarget(this.datetimeInputGroupTarget)
          break
        case "text":
          this.showOptionalTarget(this.textInputGroupTarget)
          break
        case "boolean":
          this.showOptionalTarget(this.booleanInputGroupTarget)
          break
        default:
          break
      }
    }
  }

  showOptionalTarget(target) {
    if (target) {
      target.style.display = "block"
    }
  }

  cleanupFields() {
    const groups = [
      this.textInputGroupTarget,
      this.numericInputGroupTarget,
      this.numericRangeGroupTarget,
      this.booleanInputGroupTarget,
      this.datetimeInputGroupTarget,
      this.datetimeRangeGroupTarget
    ]

    groups.forEach((group) => {
      if (group && group.style.display === "none") {
        // Remove the entire group from the DOM
        group.remove()
      }
    })
  }
}
