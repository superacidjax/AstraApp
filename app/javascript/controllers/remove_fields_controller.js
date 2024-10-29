import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  remove(event) {
    event.preventDefault();
    const wrapper = event.target.closest(".nested-fields");
    if (wrapper) {
      const destroyField = wrapper.querySelector("input[name*='_destroy']");
      if (destroyField) {
        destroyField.value = '1';
        wrapper.style.display = 'none';
      } else {
        wrapper.remove();
      }
    }
  }
}
