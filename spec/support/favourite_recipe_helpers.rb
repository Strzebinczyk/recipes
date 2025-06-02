module Support
  module FavouriteRecipeHelpers
    def add_recipe_to_favourites(recipe_name = 'Biszkopt bezowy z galaretką') # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      visit home_index_path

      expect(page).to have_content(recipe_name)

      title = find('a', text: recipe_name).ancestor('.title')
      img = title.sibling('.relative')
      scroll_to(img, align: :center)
      within img do
        find('.recipe-thumbnail img').hover
      end
      find('.add-to-favourites').click

      visit favourite_recipes_path

      expect(page).to have_content('Ulubione przepisy')
      expect(page).to have_content(recipe_name)
    end

    def remove_recipe_from_favourites(recipe_name) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      visit favourite_recipes_path

      expect(page).to have_content(recipe_name)

      title = find('a', text: recipe_name).ancestor('.title')
      img = title.sibling('.relative')
      scroll_to(img, align: :center)
      within img do
        find('.recipe-thumbnail img').hover
      end
      find('.remove_from-favourites').click

      visit favourite_recipes_path

      expect(page).to have_content('Ulubione przepisy')
      expect(page).not_to have_content(recipe_name)
    end
  end
end
