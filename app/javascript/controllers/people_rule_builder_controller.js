import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["clientApplications", "traitSelector"];
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
      selectElement.appendChild(option);
    });

    console.log("Trait selector populated and shown");
  }
}
