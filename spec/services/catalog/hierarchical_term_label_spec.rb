require 'fast_spec_helper'
require 'catalog/hierarchical_term_label'

module Catalog
  RSpec.describe HierarchicalTermLabel do
    describe '.call' do
      context 'empty value' do
        subject { described_class.call('') }
        it { is_expected.to eq(nil) }
      end

      context 'known value' do
        let(:known_term) do
          'University of Notre Dame:Hesburgh Libraries:General'
        end
        subject { described_class.call(known_term) }
        it do
          is_expected.to eq(
            described_class::DEPARTMENT_LABEL_MAP.fetch(known_term)
          )
        end
      end

      context 'fallback value' do
        let(:fallback_value) { 'Prefix:Value' }
        subject { described_class.call(fallback_value) }
        it { is_expected.to eq('Value') }
      end

      context 'unknown term' do
        let(:fallback_value) { 'Prefix:Value' }
        subject { described_class.call(fallback_value, term: :spam) }
        it { is_expected.to eq('Value') }
      end
    end
  end
end
