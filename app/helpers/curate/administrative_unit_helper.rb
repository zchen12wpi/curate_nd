module Curate::AdministrativeUnitHelper
  def administrative_unit_option_listing(curation_concern, as_of:)
    # all of the curation_concern's current admin units to mark as "selected"
    selected_administrative_unit_ids = Array.wrap(curation_concern.administrative_unit)
    # The list is returned in the appropriate sequence for display
    roots = ControlledVocabularyService.active_hierarchical_roots(name: 'administrative_units', as_of: as_of)
    # processes the above list into an array of items for the menu.
    menu_items = ControlledVocabularyService.hierarchical_menu_options(roots: roots)
    # return the formatted html for the menu items
    formatted_html_for(menu_items, selected_administrative_unit_ids)
  end

  private

    def formatted_html_for(menu_items, selected_administrative_unit_ids)
      options = ''
      menu_items.each do |list_item|
        if !list_item.key?(:item)
          # close prior group unless it was the first one
          if !options.empty?
            options << '</optgroup>'.html_safe
          end
          # start a new group with the heading row
          options << "<optgroup label=\"#{list_item[:category_title]}\">".html_safe
        else
          # add administrative unit link to group
          administrative_unit = list_item[:item]
          options << administrative_unit_options_from_collection_for_select_with_attributes(
            [administrative_unit], 'selectable_id', 'selectable_label','indent', 'children', selected_administrative_unit_ids
          )
        end
      end
      # close the final group
      options << '</optgroup>'.html_safe
    end

    def administrative_unit_options_from_collection_for_select_with_attributes(collection, value_method, text_method, attr_name, attr_field, selected = nil)
      options = collection.map do |element|
        [ element.send(text_method), element.send(value_method), "data-" + attr_name => element.send(attr_field).size ]
      end

      selected, disabled = extract_selected_and_disabled(selected)
      select_deselect = {}
      select_deselect[:selected] = extract_values_from_collection(collection, value_method, selected)
      select_deselect[:disabled] = extract_values_from_collection(collection, value_method, disabled)

      options_for_select(options, select_deselect)
    end
end
