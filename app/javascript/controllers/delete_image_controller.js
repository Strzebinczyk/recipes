import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  delete(e) {
    e.preventDefault();
  
    document.querySelector(".destroy-image").disabled = false;
    document.querySelector("#persisted-image")?.classList.add("hidden");
    document.querySelector("#upload-preview")?.classList.add("hidden");
  }
}
