# frozen_string_literal: true

module Support
  module SlimselectHelpers
    def js_select(item_text) # rubocop:disable Metrics/MethodLength
      container = find('div.ss-main')
      within container do
        find('.ss-arrow', match: :first).click
      end
      content = find('div.ss-content', match: :first)
      within content do
        input = find('div.ss-search input').native
        input.send_keys(item_text)
      end
      list = find('div.ss-list', match: :first)
      expect(list).to have_content(item_text)
      within list do
        find('div.ss-option').click
      end
      find('body').click
    end
  end
end
