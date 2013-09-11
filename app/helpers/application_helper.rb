module ApplicationHelper
  def attribute_to_html(curation_concern, method_name, options = {})
    label = curation_concern.label_for(method_name)
    curation_concern_attribute_to_html(curation_concern, method_name, label, options)
  end

  def curation_concern_collection_path(asset)
    collection_path(asset)
  end
end