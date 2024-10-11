import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["clientApplications", "traitSelector", "operatorSelector", "valueInputGroup", "caseSensitiveGroup"];
  static values = { traits: Array };

  connect() {
    console.log("PeopleRuleBuilder connected!");
    this.allTraits = this.traitsValue;
  }

  filterTraits() {
    const selectedClientAppIds = Array.from(this.clientApplicationsTarget.selectedOptions).map(option => option.value);
    const allOptionSelected = selectedClientAppIds.includes("all");

    this.clearTraitOptions();

    const filteredTraits = allOptionSelected
      ? this.allTraits
      : this.allTraits.filter(trait => selectedClientAppIds.includes(trait.client_application_id));

    this.populateTraitSelector(filteredTraits);
  }

  clearTraitOptions() {
    const selectElement = this.traitSelectorTarget;
    while (selectElement.firstChild) {
      selectElement.removeChild(selectElement.firstChild);
    }

    const defaultOption = document.createElement("option");
    defaultOption.value = "";
    defaultOption.textContent = "Select a trait";
    selectElement.appendChild(defaultOption);
  }

  populateTraitSelector(traits) {
    const selectElement = this.traitSelectorTarget;

    traits.forEach(trait => {
      const option = document.createElement("option");
      option.value = trait.id;
      option.textContent = trait.name;
      option.dataset.valueType = trait.value_type; // Store value type in option
      selectElement.appendChild(option);
    });

    console.log("Trait selector populated and shown");
  }

  updateOperator(event) {
    const selectedTraitId = event.target.value;
    const selectedTrait = this.traitsValue.find(trait => trait.id === selectedTraitId);

    if (!selectedTrait) return;

    // Clear the operatorSelector target and reset it to have only a blank option initially
    this.operatorSelectorTarget.innerHTML = "";

    const defaultOption = document.createElement("option");
    defaultOption.value = "";
    defaultOption.textContent = "Select an operator";
    this.operatorSelectorTarget.appendChild(defaultOption);

    let operators = [];

    // Determine the operators based on the trait's value_type
    switch (selectedTrait.value_type) {
      case "text":
        operators = ["Equals", "Not equals", "Contains", "Does not contain"];
        this.caseSensitiveGroupTarget.style.display = "block"; // Show case sensitive checkbox for text traits
        break;
      case "numeric":
        operators = ["Greater than", "Less than", "Equal to", "Within Range"];
        this.caseSensitiveGroupTarget.style.display = "none"; // Hide case sensitive checkbox
        break;
      case "boolean":
        operators = ["Is", "Is not"];
        this.caseSensitiveGroupTarget.style.display = "none"; // Hide case sensitive checkbox
        break;
      case "datetime":
        operators = ["Before", "After", "Within range"];
        this.caseSensitiveGroupTarget.style.display = "none"; // Hide case sensitive checkbox
        break;
    }

    // Populate the operator dropdown
    operators.forEach(operator => {
      const option = document.createElement("option");
      option.value = operator.toLowerCase().replace(" ", "_");
      option.textContent = operator;
      this.operatorSelectorTarget.appendChild(option);
    });

    // Attach event listener for operator change
    this.operatorSelectorTarget.addEventListener("change", this.handleOperatorChange.bind(this));

    // Clear any previously added dynamic inputs
    this.clearDynamicInputs();
  }

  clearDynamicInputs() {
    while (this.valueInputGroupTarget.firstChild) {
      this.valueInputGroupTarget.removeChild(this.valueInputGroupTarget.firstChild);
    }
  }

  handleOperatorChange() {
    const selectedOperator = this.operatorSelectorTarget.value;
    const selectedTrait = this.traitSelectorTarget.options[this.traitSelectorTarget.selectedIndex];
    const valueType = selectedTrait.dataset.valueType;

    this.clearDynamicInputs();

    switch (valueType) {
      case "text":
        this.addTextInput();
        break;
      case "numeric":
        this.addNumericInput();
        break;
      case "boolean":
        this.addBooleanInput();
        break;
      case "datetime":
        this.addDateTimeInput();
        break;
    }
  }

  addTextInput() {
    const inputElement = document.createElement("input");
    inputElement.type = "text";
    inputElement.name = "rule[value]";
    inputElement.classList.add("form-control");
    this.valueInputGroupTarget.appendChild(inputElement);
  }

  addNumericInput() {
    const operator = this.operatorSelectorTarget.value;

    if (operator === "within_range") {
      const inputFrom = document.createElement("input");
      inputFrom.type = "number";
      inputFrom.name = "rule[from]";
      inputFrom.classList.add("form-control");

      const inputTo = document.createElement("input");
      inputTo.type = "number";
      inputTo.name = "rule[to]";
      inputTo.classList.add("form-control");

      const labelTo = document.createElement("span");
      labelTo.textContent = " to ";

      this.valueInputGroupTarget.appendChild(inputFrom);
      this.valueInputGroupTarget.appendChild(labelTo);
      this.valueInputGroupTarget.appendChild(inputTo);

      this.addInclusiveCheckbox();
    } else {
      const inputElement = document.createElement("input");
      inputElement.type = "number";
      inputElement.name = "rule[value]";
      inputElement.classList.add("form-control");
      this.valueInputGroupTarget.appendChild(inputElement);
    }
  }

  addBooleanInput() {
    const selectElement = document.createElement("select");
    selectElement.name = "rule[boolean_value]";
    selectElement.classList.add("form-control");

    ["True", "False"].forEach(value => {
      const option = document.createElement("option");
      option.value = value.toLowerCase();
      option.textContent = value;
      selectElement.appendChild(option);
    });

    this.valueInputGroupTarget.appendChild(selectElement);
  }

  addDateTimeInput() {
    const operator = this.operatorSelectorTarget.value;

    if (operator === "within_range") {
      const inputFrom = document.createElement("input");
      inputFrom.type = "datetime-local";
      inputFrom.name = "rule[from]";
      inputFrom.classList.add("form-control");

      const inputTo = document.createElement("input");
      inputTo.type = "datetime-local";
      inputTo.name = "rule[to]";
      inputTo.classList.add("form-control");

      const labelTo = document.createElement("span");
      labelTo.textContent = " to ";

      this.valueInputGroupTarget.appendChild(inputFrom);
      this.valueInputGroupTarget.appendChild(labelTo);
      this.valueInputGroupTarget.appendChild(inputTo);

      this.addInclusiveCheckbox();
    } else {
      const inputElement = document.createElement("input");
      inputElement.type = "datetime-local";
      inputElement.name = "rule[value]";
      inputElement.classList.add("form-control");
      this.valueInputGroupTarget.appendChild(inputElement);
    }
  }

  addInclusiveCheckbox() {
    const checkboxDiv = document.createElement("div");
    checkboxDiv.classList.add("form-group");

    const checkboxLabel = document.createElement("label");
    checkboxLabel.textContent = "Values inclusive";

    const checkboxInput = document.createElement("input");
    checkboxInput.type = "checkbox";
    checkboxInput.name = "rule[inclusive]";
    checkboxInput.value = "true";

    checkboxDiv.appendChild(checkboxLabel);
    checkboxDiv.appendChild(checkboxInput);

    this.valueInputGroupTarget.appendChild(checkboxDiv);
  }
}
