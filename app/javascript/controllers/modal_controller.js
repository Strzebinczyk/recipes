import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.element.addEventListener('click', event => {
      if (event.target == this.element) {
        this.element.remove();
      }
    })
  }

  close(e) {
    e.preventDefault();
    this.element.remove();
  }
}
