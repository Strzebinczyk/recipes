# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Plans', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:plan) { create(:plan, user: user) }
  let(:other_plan) { create(:plan) }
  let(:recipe) { create(:recipe) }

  context 'when user is authenticated' do
    before do
      sign_in user
    end

    describe 'GET /index' do
      it 'gets plans index page' do
        get plans_path
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'GET /plans/new' do
      it 'gets new plan page' do
        get new_plan_path

        expect(response).to have_http_status(:ok)
      end
    end

    describe 'GET /plans/:id' do
      it 'gets plan show page' do
        get plan_path(plan)

        expect(response).to have_http_status(:ok)
      end
    end

    describe 'POST /plans' do
      it 'creates plan successfully' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
        post plans_path, params: { plan: {
          name: 'A name'
        } }
        plan = Plan.last

        expect(plan).to be_present
        expect(plan.name).to eq('A name')
        expect(response).to redirect_to(plans_path)
      end

      it 'bad request when plan data is empty' do
        post plans_path, params: { plan: {} }

        expect(response).to have_http_status(:bad_request)
      end
    end

    describe 'GET /plans/:id/edit' do
      it 'gets plans edit page' do
        get edit_plan_path(plan, format: :turbo_stream)

        expect(response).to have_http_status(:ok)
      end
    end

    describe 'PUT /plans/:id' do
      it 'updates plan successfully' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
        put plan_path(plan.id, format: :turbo_stream), params: {
          name: 'Updated plan'
        }
        plan = Plan.last

        expect(plan).to be_present
        expect(plan.name).to eq('Updated plan')
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(plan_path(plan))
      end

      it 'does not update plan when plan id is not found' do
        put plan_path(200, format: :turbo_stream), params: { plan: {
          name: 'Updated plan'
        } }

        expect(response).to have_http_status(:not_found)
      end

      it 'does not update plan when plan does not belong to user' do
        put plan_path(other_plan.id, format: :turbo_stream), params: { plan: {
          name: 'Updated plan'
        } }

        expect(response).to have_http_status(:not_found)
      end

      it 'plan not updated when details not provided' do
        put plan_path(plan.id, format: :turbo_stream), params: {}

        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    describe 'delete /plans' do
      it 'delete plan successfully' do # rubocop:disable RSpec/MultipleExpectations
        plan_id = plan.id
        delete plan_path(plan.id)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(plans_path)
        expect(Plan.exists?(plan_id)).to be false
      end

      it "deletes plan with it's recipe_plans" do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
        post add_recipe_plans_path, params: {
          plan_id: plan.id,
          recipe_id: recipe.id
        }

        recipe_plan_id = plan.recipe_plans.first.id
        plan_id = plan.id
        delete plan_path(plan.id)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(plans_path)
        expect(Plan.exists?(plan_id)).to be false
        expect(RecipePlan.exists?(recipe_plan_id)).to be false
      end

      it 'does not delete plan when plan id is not found' do
        delete plan_path(202)

        expect(response).to have_http_status(:not_found)
      end

      it 'does not delete plan when plan does not belong to user' do
        delete plan_path(other_plan.id)

        expect(response).to have_http_status(:not_found)
      end
    end

    describe 'GET /plans/new_recipe' do
      it 'gets new recipe modal' do
        get new_recipe_plans_path(recipe: recipe.id)

        expect(response).to have_http_status(:ok)
      end
    end

    describe 'POST /plans/add_recipe' do
      it 'adds recipe to plan' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
        post add_recipe_plans_path, params: {
          plan_id: plan.id,
          recipe_id: recipe.id
        }
        recipe_plan = RecipePlan.last

        expect(recipe_plan).to be_present
        expect(recipe_plan.plan_id).to eq(plan.id)
        expect(recipe_plan.recipe_id).to eq(recipe.id)
        expect(response.status).to be 302
      end

      it 'bad requests if user does not have plans created' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
        sign_in other_user

        post add_recipe_plans_path, params: {
          plan_id: plan.id,
          recipe_id: recipe.id
        }
        recipe_plan = RecipePlan.last

        expect(recipe_plan).not_to be_present
        expect(response.status).to be 404
      end
    end

    describe 'DELETE /plans/:id/remove_recipe' do
      it 'removes recipe from plan' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
        post add_recipe_plans_path, params: {
          plan_id: plan.id,
          recipe_id: recipe.id
        }

        recipe_plan = plan.recipe_plans.first
        recipe_plan_id = recipe_plan.id
        recipe_id = recipe_plan.recipe_id

        delete remove_recipe_plan_path(recipe_plan.id)

        expect(response).to have_http_status(:found)
        expect(response.status).to be 302
        expect(RecipePlan.exists?(recipe_plan_id)).to be false
        expect(Recipe.exists?(recipe_id)).to be true
      end
    end
  end

  context 'when user is not authenticated' do
    before do
      sign_in user
      post add_recipe_plans_path, params: {
        plan_id: plan.id,
        recipe_id: recipe.id
      }
      sign_out user
    end

    describe 'GET /index' do
      it 'redirects to log in page' do # rubocop:disable RSpec/MultipleExpectations
        get plans_path

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'GET /plans/new' do
      it 'redirects to log in page' do # rubocop:disable RSpec/MultipleExpectations
        get new_plan_path

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'GET /plans/:id' do
      it 'redirects to log in page' do # rubocop:disable RSpec/MultipleExpectations
        get plan_path(plan)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'POST /plans' do
      it 'redirects to log in page' do # rubocop:disable RSpec/MultipleExpectations
        post plans_path, params: { plan: {
          name: 'A name'
        } }

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'GET /plans/:id/edit' do
      it 'redirects to log in page' do # rubocop:disable RSpec/MultipleExpectations
        get edit_plan_path(plan)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'PUT /plans/:id' do
      it 'redirects to log in page' do # rubocop:disable RSpec/MultipleExpectations
        put plan_path(plan.id), params: { plan: {
          name: 'Updated plan'
        } }

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'delete /plans' do
      it 'redirects to log in page' do # rubocop:disable RSpec/MultipleExpectations
        plan_id = plan.id
        delete plan_path(plan.id)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
        expect(Plan.exists?(plan_id)).to be true
      end
    end

    describe 'GET /plans/new_recipe' do
      it 'redirects to log in page' do # rubocop:disable RSpec/MultipleExpectations
        get new_recipe_plans_path(recipe_id: recipe.id)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'POST /plans/add_recipe' do
      it 'redirects to log in page' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
        post add_recipe_plans_path, params: {
          plan_id: plan.id,
          recipe_id: recipe.id
        }

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'DELETE /plans/:id/remove_recipe' do
      it 'redirects to log in page' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
        recipe_plan = plan.recipe_plans.first
        recipe_plan_id = recipe_plan.id
        recipe_id = recipe_plan.recipe_id

        delete remove_recipe_plan_path(recipe_plan.id)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
        expect(RecipePlan.exists?(recipe_plan_id)).to be true
        expect(Recipe.exists?(recipe_id)).to be true
      end
    end
  end
end
