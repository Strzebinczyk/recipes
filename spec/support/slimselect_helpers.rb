# frozen_string_literal: true

module Support
  module SlimselectHelpers
    def js_select(item_text) # rubocop:disable Metrics/MethodLength
      container = find('div.ss-main')
      within container do
        find('.ss-arrow').click
      end
      content = find('div.ss-content')
      within content do
        input = find('div.ss-search input').native
        input.send_keys(item_text)
      end
      list = find('div.ss-list')
      within list do
        find('div').click
      end
      find('body').click
    end
  end
end
