# Patch kaminari's page_entries_info to properly pluralize in I18n context
module Kaminari
  module ActionViewExtension
    def page_entries_info(collection, options = {})
      entry_name = if options[:entry_name]
                     collection.total_count == 1 ? options[:entry_name] : options[:entry_name].pluralize(I18n.locale)
                   elsif collection.is_a?(::Kaminari::PaginatableArray)
                     'entry'
                   else
                     if collection.respond_to? :model # DataMapper
                       collection.model.model_name.human count: collection.total_count
                     else # AR
                       collection.model_name.human count: collection.total_count
                     end
                   end

      if collection.total_pages < 2
        t('helpers.page_entries_info.one_page.display_entries', entry_name: entry_name, count: collection.total_count)
      else
        first = collection.offset_value + 1
        last = collection.last_page? ? collection.total_count : collection.offset_value + collection.limit_value
        t('helpers.page_entries_info.more_pages.display_entries', entry_name: entry_name, first: first, last: last, total: collection.total_count)
      end.html_safe
    end
  end
end
