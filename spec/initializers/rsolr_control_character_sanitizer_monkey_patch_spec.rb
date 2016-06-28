require 'spec_helper'

describe 'rsolr monkey patches' do
  it 'will escape control characters on solrize' do
    expect { ActiveFedora::SolrService.add(title_tesim: "a\fb\tc", id: '123') }.to_not raise_error
  end
end

module RSolr
  class Client
    RSpec.describe SanitizeControlCharactersForIndexing do
      context '.sanitize_document' do
        it "preserves tabs, newline, and carriage return control characters but replaces others with a blank" do
          expect(described_class.sanitize_document({hello: "w\n\foot"})).to eq({ hello: "w\n oot" })
        end
      end
      context '.sanitize_value' do
        it "preserves tabs, newline, and carriage return control characters but replaces others with a blank" do
          given = "a\tb\nc\fd\re"
          expected = "a\tb\nc d\re"
          expect(described_class.sanitize_value(given)).to eq(expected)
        end
      end
    end
  end
end
