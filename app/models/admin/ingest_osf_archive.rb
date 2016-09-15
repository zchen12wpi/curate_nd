class Admin::IngestOSFArchive
  include ActiveModel::Model
  attr_accessor :project_identifier, :administrative_unit, :owner, :affiliation

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

  def as_hash
    {
      project_identifier: project_identifier,
      administrative_unit: administrative_unit,
      owner: owner,
      affiliation: affiliation,
      project_url: project_url
    }
  end

  def ==(object)
    as_hash == object.as_hash
  end

  def project_url
    osf_host_name = ENV.fetch('OSF_HOST_NAME', 'osf.io')
    osf_scheme = ENV.fetch('OSF_SCHEME', 'https')
    "#{osf_scheme}://#{osf_host_name}/#{project_identifier}/"
  end
end
