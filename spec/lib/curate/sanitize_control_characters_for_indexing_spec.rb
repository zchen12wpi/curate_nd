require 'fast_spec_helper'
require 'curate/sanitize_control_characters_for_indexing'

module Curate
  RSpec.describe SanitizeControlCharactersForIndexing do
    context '.sanitize_document' do
      it "preserves tabs, newline, and form feed control characters but replaces others with a blank" do
        expect(described_class.sanitize_document({hello: "w\n\foot"})).to eq({ hello: "w\n oot" })
      end
    end
    context '.sanitize_value' do
      it "preserves tabs, newline, and form feed control characters but replaces others with a blank" do
        given = "a\tb\nc\fd\re"
        expected = "a\tb\nc d\re"
        expect(described_class.sanitize_value(given)).to eq(expected)
      end
    end
  end
end
