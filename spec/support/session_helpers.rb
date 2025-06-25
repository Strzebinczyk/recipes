# frozen_string_literal: true

module Support
  module SessionHelpers
    def sign_up_with(email, username, password)
      visit new_user_registration_path
      fill_in 'E-mail', with: email
      fill_in 'Nick', with: username
      fill_in 'Hasło', with: password
      fill_in 'Powtórz hasło', with: password
      click_button 'Zarejestruj'
    end

    def log_in_with(email, password)
      visit new_user_session_path
      fill_in 'E-mail', with: email
      fill_in 'Hasło', with: password
      click_button 'Zaloguj'
    end
  end
end
