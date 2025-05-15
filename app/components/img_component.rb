# frozen_string_literal: true

class ImgComponent < ViewComponent::Base
  def initialize(recipe:, class_list: '')
    super()

    @recipe = recipe
    @class_list = class_list
  end
end
