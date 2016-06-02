require 'fast_spec_helper'
require 'bendo/services/refresh_file_cache'

module Bendo
  module Services
    RSpec.describe RefreshFileCache do
      describe '.call' do
        context 'with no IDs' do
          subject { described_class.call(handler: FakeApi) }
          it { is_expected.to eq({}) }
        end

        context 'with a single ID' do
          subject { described_class.call(id: '1001001001', handler: FakeApi) }
          it { is_expected.to be_kind_of(Hash) }
          its(['1001001001']) { should be true }
        end

        context 'with an Array of IDs' do
          subject { described_class.call(id: ['1001001001', 'Masks'], handler: FakeApi) }
          it { is_expected.to be_kind_of(Hash) }
          its(['1001001001']) { should be true }
          its(['Masks']) { should be true }
        end
      end
    end
  end
end
