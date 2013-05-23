require 'spec_helper'
require 'active_fedora/delegate_attributes'

describe 'ActiveFedora::DelegateAttributes' do
  class MockDelegateAttribute < ActiveFedora::Base
    include ActiveFedora::DelegateAttributes

    has_metadata :name => "properties", :type => ActiveFedora::SimpleDatastream do |m|
      m.field "title",  :string
      m.field "description",  :string
    end

    attribute :title, {
      datastream: 'properties',
      multiple: false,
      validates: { presence: true }
    }

    attribute :description, {
      datastream: 'properties',
      default: ['One two']
    }
  end
  subject { MockDelegateAttribute.new() }

  let(:reloaded_subject) { subject.class.find(subject.pid) }
  describe '.attribute' do
    it "has creates a setter/getter" do
      subject.title = 'Hello'
      subject.save!
      expect(reloaded_subject.title).to eq('Hello')
    end

    it "enforces validation when passed" do
      subject.title = nil
      subject.valid?
      expect(subject.errors[:title].size).to eq(1)
    end

    it "allows for default" do
      expect(subject.description).to eq(['One two'])
    end
  end

end
