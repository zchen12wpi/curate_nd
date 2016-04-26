# Provides a mechanism for privileged users to escalate and deescalate their
# level of access
class RepoManager < ActiveRecord::Base
  def self.find_or_initialize_by_username!(username)
    user = find_by(username: username)
    if user.present?
      user
    elsif RepositoryAdministrator.include?(username)
      find_or_create_by!(username: username, active: false)
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  def self.with_active_privileges?(user)
    with_active_privileges(user) ? true : false
  end

  private

  def self.with_active_privileges(user)
    return false unless user.present?

    if user.respond_to?(:user_key)
      username = user.user_key
    else
      username = user.to_sym
    end

    self.find_by(username: username, active: true)
  end
end
