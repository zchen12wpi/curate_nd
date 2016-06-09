require 'fast_spec_helper'
require_relative '../../config/initializers/bendo'

RSpec.describe Bendo do
  let(:service_url) { 'http://localhost:14000' }
  let(:item_path) { '/item/00000/Concatenation.pptx' }
  let(:item_url) { "#{service_url}#{item_path}" }

  describe '.url' do
    subject { described_class.url }
    it { is_expected.to eq(service_url) }
  end

  describe '.item_path' do

    context 'identifier' do
      subject { described_class.item_path('00000/Concatenation.pptx') }
      it { is_expected.to eq(item_path) }
    end

    context 'identifier with leading slash' do
      subject { described_class.item_path('/00000/Concatenation.pptx') }
      it { is_expected.to eq(item_path) }
    end

    context 'identifier with item prefix' do
      subject { described_class.item_path('item/00000/Concatenation.pptx') }
      it { is_expected.to eq(item_path) }
    end

    context 'identifier with item prefix and leading slash' do
      subject { described_class.item_path('/item/00000/Concatenation.pptx') }
      it { is_expected.to eq(item_path) }
    end
  end

  context '.item_url' do
    subject { described_class.item_url('00000/Concatenation.pptx') }
    it { is_expected.to eq(item_url) }
  end
end
