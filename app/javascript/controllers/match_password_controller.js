import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    let password = document.querySelector('.password');
    let confirmation = document.querySelector('.confirmation');
    let message = document.querySelector('#feedback')
    let submit = document.querySelector('#sign-up-btn')

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
