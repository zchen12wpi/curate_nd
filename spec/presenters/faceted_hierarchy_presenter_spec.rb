require 'spec_helper'

RSpec.describe FacetedHierarchyPresenter do

  let(:items) {
    [
      double('Item', value: 'Parent', hits: 3 ),
      double('Item', value: 'Parent:Child', hits: 2 ),
      double('Item', value: 'Parent:Child:Grandchild', hits: 1 )
    ]
  }
  let(:template) { double('Template') }
  context '#render' do
    subject { described_class.new(items: items, item_delimiter: ':', predicate_name: 'mock', facet_field_name: 'mock_sim') }
    it 'returns html_safe nested lists based on given items' do
      [
        ["Parent", "Parent", "/parent"],
        ["Parent:Child", "Child", "/parent/child"],
        ["Parent:Child:Grandchild", "Grandchild", "/parent/child/grandchild"]
      ].each do |value, slug, path|
        expect(template).to receive(:add_facet_params_and_redirect).with('mock_sim', value).and_return(path)
        expect(template).to receive(:link_to).with(slug, path, class: 'facet_select').
          and_return("<a href='#{path}' class='facet_select'>#{slug}</a>")
      end

      expect(subject.render(template: template)).to have_tag('ul.facet-hierarchy') do
        with_tag('.h-node a.facet_select', text: 'Parent')
        with_tag('.h-node .count', text: 3)
        with_tag('.h-node .h-node a.facet_select', text: 'Child')
        with_tag('.h-node .h-node .count', text: 2)
        with_tag('.h-node .h-node .h-leaf a.facet_select', text: 'Grandchild')
        with_tag('.h-node .h-node .h-leaf .count', text: 1)
      end
    end
  end

end
