import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  delete(e) {
    e.preventDefault();

    this.element.querySelector("check_box").value = "1"
    this.element.classList.add("hidden")
  }
}
