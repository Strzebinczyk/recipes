import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    const frame = document.querySelector("turbo-frame");
    if (frame.complete) {
      document.addEventListener('click', event => {
        if (!'.modal-content'.includes(event.target)) {
          const modal = document.querySelector('.modal')
          modal.classList.remove("d-block");
        }
      });
      
    }
  }

  close(e) {
    const modal = document.querySelector('.modal')
    e.preventDefault();
    modal.classList.remove("d-block");
  }
}
