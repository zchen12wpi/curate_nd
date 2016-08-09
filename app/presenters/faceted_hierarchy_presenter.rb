require 'locabulary'

# Responsible for rendering a FacetedHierarchy. The HTML fragments created are
# identical to the fragments in blacklight-hierarchy.
#
# @note Instead of using template#content_for, I'm rendering direct HTML. This is a significant rendering time improvement.
class FacetedHierarchyPresenter
  def initialize(options = {})
    @facet_field_name = options.fetch(:facet_field_name)
    @roots = Locabulary.build_ordered_hierarchical_tree(
      faceted_items: options.fetch(:items),
      faceted_item_hierarchy_delimiter: options.fetch(:item_delimiter),
      predicate_name: options.fetch(:predicate_name)
    )
  end

  def render(options={})
    # I'd prefer to set an instance variable as part of the instantiation of this object, but due to timing, this isn't as easy.
    @template = options.fetch(:template)
    html = "<ul class='facet-hierarchy'>\n"
    html << items_to_html(roots, root: true)
    html << "</ul>"
    html.html_safe
  end

  private

  def items_to_html(items, root: false)
    html = ""
    items.each do |item|
      item_class = item.children.any? ? 'h-node' : 'h-leaf'
      item_class += " #{dom_class_for(item)}" if root
      html << "<li class='#{item_class}'>\n"
      html << template.link_to(label_for(item), href_for(item), class: 'facet_select')
      html << "  <span class='count'>#{item.hits}</span>\n"
      if item.children.present?
        html << "  <ul>\n"
        html << items_to_html(item.children)
        html << "  </ul>\n"
      end
      html << "</li>\n"
    end
    html
  end

  def label_for(item)
    item.hierarchy_facet_label
  end

  def dom_class_for(item)
    item.value.downcase.gsub(/[\W]+/, '-')
  end

  def href_for(item)
    template.add_facet_params_and_redirect(facet_field_name, item.value)
  end

  attr_reader :roots, :template, :facet_field_name
end
