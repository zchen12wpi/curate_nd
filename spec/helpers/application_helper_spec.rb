require 'spec_helper'

describe ApplicationHelper do
  describe '#attribute_to_html' do
    subject { double('curation_concern', things: collection) }
    let(:collection) { ["<h2>", "Johnny Tables"] }
    it 'uses the label for when one is given' do
      label = 'Children'
      subject.stub(:label_for).with(:things).and_return(label)
      rendered = helper.attribute_to_html(subject, :things)
      rendered.should have_tag('tr') do
        with_tag("th", text: label)
        with_tag('td ul.tabular') do
          with_tag('li.attribute.things', text: '<h2>')
          with_tag('li.attribute.things', text: 'Johnny Tables')
        end
      end
    end
  end
end
