import { Controller } from "@hotwired/stimulus"
import { Autocomplete } from "src/autocomplete"

// Connects to data-controller="autocomplete"
export default class extends Controller {
  connect() {
    const data = JSON.parse(this.element.dataset.list)
    new Autocomplete(this.element, {
      data: data
    });
  }
}
