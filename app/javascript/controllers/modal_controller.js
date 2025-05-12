import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
  }

  close(e) {
    const modal = document.querySelector('.modal')
    e.preventDefault();
    modal.classList.remove("d-block");
  }
}
