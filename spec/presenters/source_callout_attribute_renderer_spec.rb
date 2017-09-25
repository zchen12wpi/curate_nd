require 'spec_helper'

RSpec.describe SourceCalloutAttributeRenderer do
  let(:view_context) { double(h: true, __render_tabular_list_item: true) }
  let(:renderer) do
    described_class.new(
      view_context: view_context,
      method_name: :source,
      value: value,
      block_formatting: false,
      tag: 'li',
      options: options
    )
  end
  let(:options) { {} }

  describe '#callout_text?' do
    subject { renderer.callout_text? }
    describe 'with a matched pattern in the given value' do
      let(:value) { 'https://undpress.nd.edu/hello-world'}
      it { is_expected.to eq(true) }
    end
    describe 'without a matched pattern in the given value' do
      let(:value) { 'https://google.com/'}
      it { is_expected.to eq(false) }
    end

    describe 'with custom callout_text and callout_pattern' do
      let(:value) { 'https://google.com' }
      let(:options) { { callout_text: 'Hello', callout_pattern: /\Ahttps?:\/\/google\.com/ }}
      it { is_expected.to eq(true)}
    end
  end

  describe '#render' do
    subject { renderer.render }
    describe 'with matched pattern' do
      let(:value) { 'https://undpress.nd.edu/hello-world'}
      it 'renders the a-tag linking to the soruce' do
        expect(view_context).to receive(:__render_tabular_list_item)
        subject
      end
    end
    describe 'without matched pattern' do
      let(:value) { 'https://google.com/'}
      it 'renders the value as a non-a-tag' do
        expect(view_context).to receive(:__render_tabular_list_item)
        subject
      end
    end
  end
end
