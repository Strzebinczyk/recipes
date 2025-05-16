import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["canvas", "source"];

  show() {
    const reader = new FileReader();
    const preview = document.querySelector(".preview")
    const closeBtn = document.querySelector("#preview-close")

    reader.onload = function () {
      this.canvasTarget.removeAttribute("hidden");
      this.canvasTarget.classList.remove("hidden");
      closeBtn.classList.remove('hidden');
      document.querySelector(".destroy-image").disabled = true;
      if(preview != null) {
        preview.classList.add("hidden");
      } else {
        closeBtn.classList.add('hidden');
      }
      this.canvasTarget.src = reader.result;
    }.bind(this)

    reader.readAsDataURL(this.sourceTarget.files[0]);
  }
}
