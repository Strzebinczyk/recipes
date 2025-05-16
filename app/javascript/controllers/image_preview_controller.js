import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["canvas", "source"];

  connect() {
    const preview = document.querySelector(".preview")
    const closeBtn = document.querySelector("#preview-close")

    if (preview != null) {
      closeBtn.classList.remove('hidden')
    }
  }

  show() {
    const reader = new FileReader();
    const preview = document.querySelector(".preview")
    const closeBtn = document.querySelector("#preview-close")

    reader.onload = function () {
      this.canvasTarget.removeAttribute("hidden");
      this.canvasTarget.classList.remove("hidden");
      closeBtn.classList.remove('hidden');
      document.querySelector(".destroy-image").disabled = true;
      if (preview != null) {
        preview.classList.add("hidden");
        closeBtn.classList.remove('hidden')
      }
      this.canvasTarget.src = reader.result;
    }.bind(this)

    reader.readAsDataURL(this.sourceTarget.files[0]);
  }
}
