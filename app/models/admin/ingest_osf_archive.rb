class Admin::IngestOSFArchive
  include ActiveModel::Model
  attr_accessor :project_identifier, :administrative_unit, :owner, :affiliation, :status

  validates :project_identifier, presence: true
  validates :administrative_unit, presence: true
  validates :owner, presence: true
  validates :affiliation, presence: true
end
