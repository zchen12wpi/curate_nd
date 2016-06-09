require 'fast_spec_helper'
require 'bendo/services/refresh_file_cache'

module Bendo
  module Services
    RSpec.describe RefreshFileCache do
      describe '.call' do
        context 'with no identifiers' do
          subject { described_class.call(handler: FakeApi) }
          its(:body) { is_expected.to eq({}) }
          its(:status) { is_expected.to eq(200) }
        end

        context 'with a single identifier' do
          subject { described_class.call(item_slugs: '1001001001', handler: FakeApi) }
          its(:body) { is_expected.to be_kind_of(Hash) }
          its(:body) { is_expected.to include('1001001001') }
          its(:status) { is_expected.to eq(200) }
        end

        context 'with an Array of identifiers' do
          subject { described_class.call(item_slugs: ['1001001001', 'Masks'], handler: FakeApi) }
          its(:body) { is_expected.to be_kind_of(Hash) }
          its(:body) { is_expected.to include('1001001001') }
          its(:body) { is_expected.to include('Masks') }
          its(:status) { is_expected.to eq(200) }
        end
      end
    end
  end
end
