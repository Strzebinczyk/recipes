# frozen_string_literal: true

module Support
  module ShoppingListHelpers
    def create_plan(name = 'Plan')
      visit new_plan_path
      fill_in 'Nazwa', with: name

      click_button 'Zapisz'

      expect(page).to have_content(name)
    end

    def add_recipe_to_plan(recipe_name = 'Biszkopt bezowy z galaretką') # rubocop:disable Metrics/AbcSize
      visit home_index_path

      expect(page).to have_content(recipe_name)

      title = find('a', text: recipe_name).ancestor('.title')
      img = title.sibling('.relative')
      scroll_to(img, align: :center)
      within img do
        find('.recipe-thumbnail img').hover
      end
      find('.add-to-plan').click

      expect(page).to have_content('Dodaj przepis do planu posiłków')

      click_button 'Zapisz'

      visit plans_path

      expect(page).to have_content('Moje plany posiłków')
      expect(page).to have_content(recipe_name)
    end

    def convert_pdf_to_page
      temp_pdf = Tempfile.new('pdf')
      temp_pdf << page.source.force_encoding('UTF-8')
      reader = PDF::Reader.new(temp_pdf)
      pdf_text = reader.pages.map(&:text)
      page.driver.response.instance_variable_set('@body', pdf_text)
    end
  end
end
