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

RepositoryAdministrator.usernames.each do |username|
  next if RepoManager.find_by(username: username)
  RepoManager.find_or_create_by!(username: username, active: true)
end
