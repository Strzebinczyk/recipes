import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
  }
  close(e) {
    e.preventDefault();
    this.classList.remove("d-block");
  }
}
