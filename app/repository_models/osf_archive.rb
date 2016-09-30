class OsfArchive < ActiveFedora::Base
  include CurationConcern::Work
  include CurationConcern::WithGenericFiles
  include CurationConcern::Embargoable
  include CurationConcern::WithRecordEditors
  include CurationConcern::WithRecordViewers
  include ActiveFedora::RegisteredAttributes
  include CurationConcern::RemotelyIdentifiedByDoi::Attributes

  after_initialize :set_default_values

  before_validation :set_initial_values, on: :create

  class_attribute :human_readable_short_description
  self.human_readable_short_description = "Change me."

  def self.human_readable_type
    'OSF Archive'
  end

  def set_default_values
    self.type = 'OSF Archive'
  end
  private :set_default_values

  def set_initial_values
    self.date_modified = Date.today
    self.date_archived = Date.today
  end
  private :set_initial_values

  has_metadata 'descMetadata', type: OsfArchiveDatastream

  attribute :affiliation,
    datastream: :descMetadata,
    hint: "Creator's Affiliation to the Institution.",
    multiple: false

  attribute :creator,
    datastream: :descMetadata, multiple: true

  attribute :title,
    datastream: :descMetadata, multiple: false,
    validates: {presence: { message: 'Your archive must have a title.' }}

  attribute :source,
    datastream: :descMetadata, multiple: false,
    label: 'Original OSF Project',
    validates: {
      format: {
      with: URI::regexp(%w(http https ftp)),
      message: 'must be a valid URL.'
      }
    }

  attribute :subject,
    datastream: :descMetadata, multiple: true

  attribute :type,
    datastream: :descMetadata, multiple: false,
    validates: {presence: { message: 'Archive type is required.' }}

  attribute :language,
    datastream: :descMetadata, multiple: true

  attribute :administrative_unit,
    datastream: :descMetadata, multiple: true,
    label: "Departments and Units",
    hint: "Departments and Units that creator belong to."

  attribute :description,
    datastream: :descMetadata, multiple: false,
    validates: {presence: { message: 'Your archive must have a description.' }}

  attribute :date_created,
    datastream: :descMetadata, multiple: false,
    default: lambda { Date.today.to_s("%Y-%m-%d") },
    label: "Date object was created in the OSF",
    validates: {presence: { message: 'Created date is required.' }}

  attribute :date_modified,
    datastream: :descMetadata, multiple: false,
    validates: {presence: { message: 'Modified date is required.' }}

  attribute :date_archived,
    datastream: :descMetadata, multiple: false,
    label: "Date Archived",
    validates: {presence: { message: 'Archived date is required.' }}

  attribute :rights,
    datastream: :descMetadata, multiple: false,
    default: "All rights reserved",
    validates: { presence: { message: 'You must select a license for your work.' } }

  attribute :doi,
    datastream: :descMetadata, multiple: true
end
