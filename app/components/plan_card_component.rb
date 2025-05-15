# frozen_string_literal: true

class PlanCardComponent < ViewComponent::Base
  def initialize(plan:)
    super()

    @plan = plan
  end
end
