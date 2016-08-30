class Admin::IngestOSFArchive
  include ActiveModel::Model
  attr_accessor :project_url, :project_identifier, :department, :owner

  validates :project_url, presence: true
  validates :project_identifier, presence: true
  validates :department, presence: true
  validates :owner, presence: true
end
