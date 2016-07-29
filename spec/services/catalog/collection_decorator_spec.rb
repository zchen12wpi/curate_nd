require 'fast_spec_helper'
require 'catalog/collection_decorator'

module Catalog
  RSpec.describe CollectionDecorator do
    describe '.call' do
      context 'with nil' do
        let(:empty_attribute) { nil }
        subject { described_class.call(empty_attribute, data_source: described_class::FakeAdapter) }
        it { is_expected.to eq('') }
      end

      context 'with empty string' do
        let(:empty_attribute) { '' }
        subject { described_class.call(empty_attribute, data_source: described_class::FakeAdapter) }
        it { is_expected.to eq('') }
      end

      context 'with only pid' do
        let(:single_pid) { 'und:1234' }
        subject { described_class.call(single_pid, data_source: described_class::FakeAdapter) }
        it { is_expected.to eq('und:1234') }
      end

      context 'with tile and embedded pid' do
        let(:single_slug) { 'Helpful Title|und:1337' }
        subject { described_class.call(single_slug, data_source: described_class::FakeAdapter) }
        it { is_expected.to eq('und:1337') }
      end

      context 'with pid path' do
        let(:pid_path) { 'und:1234/und:4567/und:1337' }
        subject { described_class.call(pid_path, data_source: described_class::FakeAdapter) }
        it { is_expected.to eq('und:1337') }
      end

      context 'with title and embedded pid path' do
        let(:slug_path) { 'Large Collection|und:1234/Arbitrary Container|und:4567/Helpful Title|und:1337' }
        subject { described_class.call(slug_path, data_source: described_class::FakeAdapter) }
        it { is_expected.to eq('und:1337') }
      end
    end

    describe '.title_from_scope' do
      context 'with tile and embedded pid' do
        let(:single_slug) { 'Helpful Title|und:1337' }
        subject { described_class.title_from_scope(single_slug) }
        it { is_expected.to eq('Helpful Title') }
      end

      context 'with pid path' do
        let(:pid_path) { 'und:1234/und:4567/und:1337' }
        subject { described_class.title_from_scope(pid_path) }
        it { is_expected.to eq('und:1337') }
      end

      context 'with title and embedded pid path' do
        let(:slug_path) { 'Large Collection|und:1234/Arbitrary Container|und:4567/Helpful Title|und:1337' }
        subject { described_class.title_from_scope(slug_path) }
        it { is_expected.to eq('Helpful Title') }
      end
    end
  end
end
