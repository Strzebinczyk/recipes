# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Recipes', type: :request do
  let(:recipe) { create(:recipe) }
  let(:user) { create(:user) }
  let(:recipe_with_tags) { create(:recipe_with_tags) }
  let(:tag) { create(:tag) }

  describe 'GET /recipes/:id' do
    it 'gets recipe show page' do
      get recipe_path(recipe)

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /recipes/new' do
    it 'gets new recipe page' do
      sign_in user
      get new_recipe_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /recipes' do
    context 'when user is authenticated' do
      before do
        sign_in user
      end

      it 'creates recipe successfully' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
        post recipes_path, params: { recipe: {
          name: 'Valid recipe',
          serving: 2,
          steps_attributes: [instructions: 'Boil water'],
          recipe_ingredients_attributes: { RecipeIngredient.new.hash => { name: 'Fish', quantity: '1' } }
        } }
        recipe = Recipe.last
        step = Step.last
        ingredient = Ingredient.last
        recipe_ingredient = RecipeIngredient.last

        expect(step).to be_present
        expect(step.instructions).to eq('Boil water')
        expect(step.recipe_id).to eq(recipe.id)
        expect(ingredient).to be_present
        expect(ingredient.name).to eq('Fish')
        expect(recipe_ingredient).to be_present
        expect(recipe_ingredient.quantity).to eq('1')
        expect(recipe).to be_present
        expect(recipe.name).to eq('Valid recipe')
        expect(recipe.serving).to eq(2)
        expect(response).to redirect_to(recipe_path(recipe))
      end

      it 'creates a recipe with tags' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
        post recipes_path, params: { recipe: {
          name: 'Valid recipe',
          tag_ids: ['', tag.id],
          serving: 2,
          steps_attributes: [instructions: 'Boil water'],
          recipe_ingredients_attributes: { RecipeIngredient.new.hash => { name: 'Fish', quantity: '1' } }
        } }
        recipe = Recipe.last
        tag = recipe.tags[0]

        expect(tag).to be_present
        expect(tag.id).to eq(1)
        expect(response).to redirect_to(recipe_path(recipe))
      end

      it 'bad request when recipe data is empty' do
        post recipes_path, params: { recipe: {} }

        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to log in page' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
        post recipes_path, params: { recipe: {
          name: 'Valid recipe',
          serving: 2,
          steps_attributes: [instructions: 'Boil water'],
          recipe_ingredients_attributes: { RecipeIngredient.new.hash => { name: 'Fish', quantity: '1' } }
        } }

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET /recipes/:id/edit' do
    it 'gets recipe edit page' do
      sign_in user
      get edit_recipe_path(recipe)

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PUT /recipes/:id' do
    context 'when user is authenticated' do
      before do
        Rails.application.load_seed
        sign_in user
      end

      it 'updates recipe successfully' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
        put recipe_path(recipe.id), params: { recipe: {
          name: 'Updated recipe',
          serving: 10,
          steps_attributes: [instructions: 'Updated step'],
          recipe_ingredients_attributes: { RecipeIngredient.new.hash => { name: 'Updated ingredient',
                                                                          quantity: 'Updated quantity' } }
        } }
        recipe = Recipe.last
        step = Step.last
        ingredient = Ingredient.last
        recipe_ingredient = RecipeIngredient.last

        expect(recipe).to be_present
        expect(recipe.name).to eq('Updated recipe')
        expect(recipe.serving).to eq(10)
        expect(ingredient.name).to eq('Updated ingredient')
        expect(recipe_ingredient.quantity).to eq('Updated quantity')
        expect(step.instructions).to eq('Updated step')
        expect(step.recipe_id).to eq(recipe.id)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(recipe_path(recipe))
      end

      it 'adds an ingredient in an existing recipe' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
        put recipe_path(recipe.id), params: { recipe: {
          name: 'Updated recipe',
          recipe_ingredients_attributes: { RecipeIngredient.new.hash => { name: 'Carrot', quantity: '3' } }
        } }
        recipe = Recipe.last
        ingredient = Ingredient.last
        recipe_ingredient = RecipeIngredient.last

        expect(ingredient).to be_present
        expect(recipe.name).to eq('Updated recipe')
        expect(ingredient.name).to eq('Carrot')
        expect(recipe_ingredient.quantity).to eq('3')
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(recipe_path(recipe))
      end

      it 'edits an existing ingredient in a recipe' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
        ingredient = recipe.ingredients.first
        recipe_ingredient = ingredient.recipe_ingredients.first

        put recipe_path(recipe.id), params: { recipe: {
          recipe_ingredients_attributes:
          { recipe_ingredient.id => { id: recipe_ingredient.id, ingredient_id: ingredient.id,
                                      name: 'Updated ingredient', quantity: 'Updated quantity' } }
        } }

        ingredient = recipe.ingredients.last

        expect(ingredient.reload).to be_present
        expect(recipe_ingredient.reload).to be_present
        expect(ingredient.name).to eq('Updated ingredient')
        expect(recipe_ingredient.quantity).to eq('Updated quantity')
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(recipe_path(recipe))
      end

      it 'deletes an ingredient in a recipe' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
        recipe_ingredient = recipe.recipe_ingredients.first
        recipe_ingredient_id = recipe_ingredient.id
        ingredient_id = recipe_ingredient.ingredient_id
        ingredient = Ingredient.find_by(id: ingredient_id)

        put recipe_path(recipe.id), params: { recipe: {
          recipe_ingredients_attributes: {
            recipe_ingredient_id => {
              id: recipe_ingredient_id, name: ingredient.name, quantity: recipe_ingredient.quantity, _destroy: true
            }
          }
        } }

        expect(Ingredient.exists?(ingredient_id)).to be true
        expect(RecipeIngredient.exists?(recipe_ingredient_id)).to be false
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(recipe_path(recipe))
      end

      it 'adds a step in an existing recipe' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
        put recipe_path(recipe.id), params: { recipe: {
          name: 'Updated recipe',
          steps_attributes: [instructions: 'Boil a pot of water']
        } }
        recipe = Recipe.last
        step = Step.last

        expect(step).to be_present
        expect(recipe.name).to eq('Updated recipe')
        expect(step.instructions).to eq('Boil a pot of water')
        expect(step.recipe_id).to eq(recipe.id)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(recipe_path(recipe))
      end

      it 'edits an existing step in a recipe' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
        step = recipe.steps.first
        put recipe_path(recipe.id), params: { recipe: {
          steps_attributes: [id: step.id, instructions: 'Updated step']
        } }

        expect(step.reload).to be_present
        expect(step.instructions).to eq('Updated step')
        expect(step.recipe_id).to eq(recipe.id)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(recipe_path(recipe))
      end

      it 'deletes a step in a recipe' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
        step = recipe.steps.first
        put recipe_path(recipe.id), params: { recipe: {
          steps_attributes: [id: step.id, _destroy: true]
        } }

        expect(Step.exists?(step.id)).to be false
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(recipe_path(recipe))
      end

      it 'adds a tag in an existing recipe' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
        put recipe_path(recipe.id), params: { recipe: {
          tag_ids: ['', '2']
        } }

        expect(recipe.tags[0].name).to eql 'Ciasto'
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(recipe_path(recipe))
      end

      it 'deletes a tag in an existing recipe' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
        put recipe_path(recipe_with_tags.id), params: { recipe: {
          tag_ids: ['']
        } }

        expect(recipe_with_tags.tags).to eq []
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(recipe_path(recipe_with_tags))
      end

      it 'does not update recipe when recipe id is not found' do # rubocop:disable RSpec/ExampleLength
        put recipe_path(200), params: { recipe: {
          name: 'Updated recipe',
          serving: 10,
          recipe_ingredients_attributes: { RecipeIngredient.new.hash => { name: 'Fish', quantity: '1' } }
        } }

        expect(response).to have_http_status(:not_found)
      end

      it 'recipe not updated when details not provided' do
        put recipe_path(recipe.id), params: { recipe: {} }

        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when user is not authenticated' do
      it 'does not update recipe' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
        put recipe_path(recipe.id), params: { recipe: {
          name: 'Updated recipe',
          serving: 10,
          recipe_ingredients_attributes: { RecipeIngredient.new.hash => { name: 'Fish', quantity: '1' } }
        } }

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'delete /recipes' do
    context 'when user is authenticated' do
      before do
        sign_in user
      end

      it 'delete recipe successfully' do # rubocop:disable RSpec/MultipleExpectations
        recipe_id = recipe.id
        delete recipe_path(recipe.id)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(home_index_path)
        expect(Recipe.exists?(recipe_id)).to be false
      end

      it "deletes recipe with it's steps" do # rubocop:disable RSpec/MultipleExpectations,RSpec/ExampleLength
        step_id = recipe.steps.first.id
        recipe_id = recipe.id
        delete recipe_path(recipe.id)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(home_index_path)
        expect(Recipe.exists?(recipe_id)).to be false
        expect(Step.exists?(step_id)).to be false
      end

      it 'does not delete recipe when recipe id is not found' do
        delete recipe_path(2002)

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when user is not authenticated' do
      it 'does not delete recipe' do # rubocop:disable RSpec/MultipleExpectations
        put recipe_path(recipe.id)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
