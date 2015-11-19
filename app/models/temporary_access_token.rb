class TemporaryAccessToken < ActiveRecord::Base
  self.primary_key = 'sha'
  paginates_per 15

  HOURS_UNTIL_EXPIRY = 24

  def self.permitted?(noid, sha)
    valid_tokens(noid, sha).any?
  end

  def self.use!(sha)
    tokens = self.where(sha: sha)
    updated_tokens  = []

    tokens.each do |token|
      if token.expiry_date.blank?
        token.update_attribute(:expiry_date, new_expiry_date)
        updated_tokens << token
      end
    end

    updated_tokens.any?
  end

  def self.valid_tokens(noid, sha)
    self.where(noid: noid, sha: sha).where("#{self.quoted_table_name}.`expiry_date` IS NULL OR #{self.quoted_table_name}.`expiry_date` >= ?", Time.now)
  end
  private_class_method :valid_tokens

  def self.new_expiry_date
    Time.now + HOURS_UNTIL_EXPIRY.hours
  end
  private_class_method :new_expiry_date

  validates_presence_of :noid, :issued_by
  validates_uniqueness_of :sha
  before_create :assign_new_sha, :strip_pid_namespace

  def assign_new_sha
    assign_attributes(sha: generate_sha)
  end
  private :assign_new_sha

  def generate_sha
    SecureRandom.urlsafe_base64(32, false)
  end
  private :generate_sha

  def strip_pid_namespace
    assign_attributes(noid: Sufia::Noid.noidify(noid))
  end
  private :strip_pid_namespace
end
