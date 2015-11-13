class TemporaryAccessToken < ActiveRecord::Base
  self.primary_key = 'sha'

  def self.permitted?(noid, sha)
    false #stub
  end

  def self.expire!(sha)
    true #stub
  end

  validates_presence_of :noid, :issued_by
  validates_uniqueness_of :sha
  before_create :assign_new_sha

  def assign_new_sha
    assign_attributes(sha: generate_sha)
  end
  private :assign_new_sha

  def generate_sha
    SecureRandom.urlsafe_base64(32, false)
  end
  private :generate_sha
end
