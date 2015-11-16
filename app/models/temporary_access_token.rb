class TemporaryAccessToken < ActiveRecord::Base
  self.primary_key = 'sha'
  paginates_per 15

  def self.permitted?(noid, sha)
    valid_tokens = self.where(noid: noid).where(sha: sha).where(used: false)
    valid_tokens.any?
  end

  def self.expire!(sha)
    tokens = self.where(sha: sha).where(used: false)

    if tokens.count == 1
      tokens.first.update_attribute(:used, true)
    else
      false
    end
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
