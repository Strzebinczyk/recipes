# frozen_string_literal: true

class NavElementComponent < ViewComponent::Base
  def initialize(img_path:, path: '#', text: '', tag_list: [])
    super()

    @path = path
    @img_path = img_path
    @text = text
    @tag_list = tag_list
  end
end
