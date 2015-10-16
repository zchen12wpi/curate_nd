###############################################################################
###############################################################################
####
####
####  ATTENTION: db/seeds.rb should be something that can be run repeatedly
####    without duplicating data on the underlying application.
####
####
###############################################################################
###############################################################################

manager_usernames_config = Rails.root.join('config/manager_usernames.yml')
if manager_usernames_config.exist?
  YAML.load(ERB.new(manager_usernames_config.read).result).fetch(Rails.env).fetch('manager_usernames').each do |username|
    next if RepoManager.find_by(username: username)
    RepoManager.find_or_create_by!(username: username, active: true)
  end
else
  $stderr.puts "Unable to find manager_usernames file: #{manager_usernames_config}"
end
