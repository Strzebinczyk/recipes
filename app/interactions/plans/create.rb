# frozen_string_literal: true

module Plans
  class Create < ActiveInteraction::Base
    object :user
    hash :params, strip: false

    def execute
      plan = user.plans.build(params)
      shopping_list = plan.build_shopping_list

      errors.merge!(plan.errors) unless plan.save
      errors.merge!(shopping_list.errors) unless shopping_list.save
      plan
    end
  end
end
