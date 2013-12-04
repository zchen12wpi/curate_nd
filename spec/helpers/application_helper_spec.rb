require 'spec_helper'

describe ApplicationHelper do
  context '#curation_concern_collection_path' do
    it 'should use #collection_path' do
      expect(curation_concern_collection_path(id: '1234')).to eq('/collections/1234')
    end
  end
  context '#curation_concern_person_path' do
    it 'should use #person_path' do
      expect(curation_concern_person_path(id: '1234')).to eq('/people/1234')
    end
  end
end
