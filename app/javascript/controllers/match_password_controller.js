import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const password = document.querySelector('.password');
    const confirmation = document.querySelector('.confirmation');
    const message = document.querySelector('#feedback')
    const submit = document.querySelector('#sign-up-btn')

    function checkPassword () {
      if (password.value == confirmation.value) {
        confirmation.classList.remove('is-invalid');
        message.classList.remove('d-block');
        submit.classList.remove('disabled')
      } else {
        confirmation.classList.add('is-invalid');
        message.classList.add('d-block');
        submit.classList.add('disabled')
      }
    }

    password.addEventListener('keyup', () => {
      if(confirmation.value.length != 0) checkPassword();
    })

    confirmation.addEventListener('keyup', checkPassword);
  }
}
