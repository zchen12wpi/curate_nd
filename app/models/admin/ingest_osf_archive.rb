class Admin::IngestOSFArchive
  include ActiveModel::Model
  attr_accessor :project_identifier, :administrative_unit, :owner, :affiliation, :status

  validates :project_identifier, presence: true
  validates :administrative_unit, presence: true
  validates :owner, presence: true
  validates :affiliation, presence: true

  # Supports constructing an IngestOSFArchive using a URL or an ID
  # for the project_identifier attribute.
  # Expects an OSF URL of the form:
  #   http(s)://hostname/:id
  def self.build_with_id_or_url(attributes)
    if attributes.include?(:project_identifier)
      match = /^https?:\/\/[^\/]*\/([^\/]*).*$/.match attributes[:project_identifier]
      attributes[:project_identifier] = match[1] if match && match.length > 1
    end
    new(attributes)
  end
end
