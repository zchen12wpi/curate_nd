class Admin::UserWhitelist < ActiveRecord::Base
  validates :username, { uniqueness: true, presence: true }

  def self.whitelisted?(user)
    return false unless user.present?
    return true if Rails.env.staging?
    username = user.respond_to?(:username) ? user.username : user
    CurateND::AdminConstraint.is_admin?(username) || exists?(username: username)
  end
end
