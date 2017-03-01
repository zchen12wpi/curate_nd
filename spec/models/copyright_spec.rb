require 'spec_helper'
require 'copyright'

RSpec.describe Copyright do
  describe '.active' do
    it 'delegates to Locabulary' do
      expect(Locabulary).to receive(:active_items_for).with(predicate_name: 'copyright', as_of: kind_of(Time)).and_call_original
      expect(described_class.active).to be_a(Array)
    end
  end

  describe '.active_for_select' do
    subject { described_class.active_for_select }
    it { is_expected.to be_a(Hash) }
  end

  describe '.default_persisted_value' do
    subject { described_class.default_persisted_value }
    it { is_expected.to be_a(String) }
  end

  describe '.label_from_uri' do
    it 'converts the URI into a human meaningful string' do
      expect(described_class.label_from_uri('http://creativecommons.org/publicdomain/mark/1.0/')).to eq('Public Domain Mark 1.0')
    end

    it 'returns the URI that was given if it was a missing URI' do
      expect(described_class.label_from_uri('http://somewhere.over.the.rainbow/')).to eq('http://somewhere.over.the.rainbow/')
    end
  end

  describe '.persisted_value_for!' do
    it 'converts found keys' do
      expect(described_class.persisted_value_for!('All rights reserved')).to eq('All rights reserved')
      expect(described_class.persisted_value_for!('Public Domain Mark 1.0')).to eq('http://creativecommons.org/publicdomain/mark/1.0/')
    end

    it 'raises an exception when a key is missing' do
      expect { described_class.persisted_value_for!('Missing!') }.to raise_error(Locabulary::Exceptions::ItemNotFoundError)
    end
  end
end
