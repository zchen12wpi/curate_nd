module CurationConcernHelper
  def curation_concern_form_for(object, *args, &block)
    options = args.extract_options!
    simple_form_for(object, *(args << options.merge(builder: CurationConcernFormBuilder)), &block)
  end

  def decode_administrative_unit(curation_concern, method_name, label = nil, options = { class: 'descriptive-text' }, decorator: Catalog::HierarchicalValuePresenter)
    return unless curation_concern.respond_to?(:administrative_unit)
    markup = ""
    label ||= derived_label_for(curation_concern, method_name)
    administrative_unit = curation_concern.public_send(method_name)
    return markup if administrative_unit.blank?
    markup << %(<tr><th>#{label}</th>\n<td><ul class='tabular'>)
    [administrative_unit].flatten.compact.each do |hierarchy|
      markup << safe_join(decorator.send(:call, value: hierarchy, opener: '<li class="attribute">', closer: '</li>', link: true))
    end
    markup << %(</ul></td></tr>)
    markup.html_safe
  end
end
