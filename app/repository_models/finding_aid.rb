require 'curation_concern/model'
require 'active_fedora/registered_attributes'
class FindingAid < ActiveFedora::Base
  include ActiveFedora::RegisteredAttributes
  include CurationConcern::Work
  include CurationConcern::WithGenericFiles
  include CurationConcern::WithLinkedContributors
  include CurationConcern::Embargoable 
  include CurationConcern::WithEditors

  before_create :set_visibility_to_open_access

  has_metadata "descMetadata", type: FindingAidRdfDatastream, control_group: 'M'

  class_attribute :human_readable_short_description
  self.human_readable_short_description = "Deposit a EAD Finding Aid."

  attribute :title,
    datastream: :descMetadata, multiple: false,
    label: "Title of your Finding Aid",
    validates: { presence: { message: 'Your Finding Aid must have a title.' } }
  attribute :creator, datastream: :descMetadata, multiple: true, validates: { multi_value_presence: true }
  attribute :contributor,
    datastream: :descMetadata, multiple: true,
    label: "Contributing Author(s)"
  attribute :abstract,
    label: "Abstract or Summary of the Finding Aid",
    datastream: :descMetadata, multiple: false,
    validates: { presence: { message: 'Your Finding Aid must have an abstract.' } }
  attribute :files,
    multiple: true, form: {as: :file}, label: "Upload Files",
    hint: "CTRL-Click (Windows) or CMD-Click (Mac) to select multiple files."
  attribute :identifier, datastream: :descMetadata, multiple: false
  attribute :date_uploaded,
    default: Date.today.to_s("%Y-%m-%d")
  attribute :date_modified,
    default: Date.today.to_s("%Y-%m-%d")
  attribute :rights,
    datastream: :descMetadata, multiple: false,
    default: "All rights reserved",
    validates: { presence: { message: 'You must select a license for your work.' } }

  private
  def set_visibility_to_open_access
    self.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
  end

end
