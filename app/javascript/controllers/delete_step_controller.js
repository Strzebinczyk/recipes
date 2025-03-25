import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  delete(e) {
    e.preventDefault();

    this.element.querySelector(".destroy-step").value = true
    this.element.classList.toggle("hidden")
  }
}
