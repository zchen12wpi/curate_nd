# Provides a simple API for retrieving ids of users who are permitted to act as
# a repository administrator.
class RepositoryAdministrator

  def self.usernames
   @usernames ||= load_usernames
  end

  def self.include?(user_key)
    user_key = user_key.to_s
    !!usernames.include?(user_key)
  end

  private

  def self.load_usernames
    manager_usernames_config = Rails.root.join('config/admin_usernames.yml')
    if manager_usernames_config.exist?
      interpreted_config = YAML.load(ERB.new(manager_usernames_config.read).result)
      admin_usernames = interpreted_config.fetch(Rails.env).fetch('admin_usernames')
      Array.wrap(admin_usernames)
    else
      $stderr.puts "Unable to find admin_usernames file: #{manager_usernames_config}"
      []
    end
  end
end
