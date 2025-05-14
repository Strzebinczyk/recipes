import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    if (document.readyState == "complete") {
      document.addEventListener('click', event => {
        const modal_content = document.querySelector('.modal-content');
        if (!modal_content.contains(event.target)) {
          const modal = document.querySelector('.modal');
          modal.classList.remove("d-block");
        }
      })
    }
    
      
  }

  close(e) {
    const modal = document.querySelector('.modal');
    e.preventDefault();
    modal.classList.remove("d-block");
  }
}
