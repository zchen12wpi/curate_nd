require 'fast_spec_helper'
require 'catalog/collection_decorator'

module Catalog
  RSpec.describe CollectionDecorator do
    describe '.call' do
      context 'empty attribute' do
        let(:empty_attribute) { '' }
        subject { described_class.call(empty_attribute, data_source: described_class::FakeAdapter) }
        it { is_expected.to eq('') }
      end
    end
  end
end
