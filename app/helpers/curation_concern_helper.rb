module CurationConcernHelper
  def curation_concern_form_for(object, *args, &block)
    options = args.extract_options!
    simple_form_for(object, *(args << options.merge(builder: CurationConcernFormBuilder)), &block)
  end

  def decode_administrative_unit(curation_concern, method_name, label = nil, options = { class: 'descriptive-text' })
    markup = ""
    label ||= derived_label_for(curation_concern, method_name)
    administrative_unit = curation_concern.public_send(method_name)
    return markup if administrative_unit.blank?
    markup << %(<tr><th>#{label}</th>\n<td><ul class='tabular'>)
    [administrative_unit].flatten.compact.each do |hierarchy|
      markup << %(<ul class='breadcrumb'><li>)
      markup << hierarchy.split("::").join("</li><span class='divider'>/</span><li>")
      markup << %(</ul></li>)
    end
    markup << %(</ul></td></tr>)
    markup.html_safe
  end
end
