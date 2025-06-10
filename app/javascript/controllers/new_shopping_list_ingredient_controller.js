import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    const submit_btn = document.querySelector('#submit_btn');

    const observer = new MutationObserver((mutationList) => {
      mutationList
        .forEach(() => {
          checkIfEmpty(this.element);
        });
    });

    observer.observe(this.element, { childList: true, subtree: true });

    function checkIfEmpty(el) {
      if (el.hasChildNodes()) {
        submit_btn.classList.remove('d-none');
      }
    }
  }
}
