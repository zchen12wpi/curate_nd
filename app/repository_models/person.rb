require 'active_fedora/registered_attributes'

class Person < ActiveFedora::Base
  include ActiveFedora::RegisteredAttributes

  has_metadata name: "descMetadata", type: ActiveFedora::QualifiedDublinCoreDatastream do |ds|
    ds.field :display_name, :string
    ds.field :preferred_email, :string
    ds.field :alternate_email, :string
  end

  attribute :display_name,
      datastream: :descMetadata, multiple: false

  attribute :preferred_email,
      datastream: :descMetadata, multiple: false

  attribute :alternate_email,
      datastream: :descMetadata, multiple: false
end
