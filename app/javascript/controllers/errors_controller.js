import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const field = this.element.previousElementSibling.children[0]
    field.classList.add("is-invalid")
  }
}
