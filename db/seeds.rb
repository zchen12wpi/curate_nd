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

# Initialize authority groups if they don't already exist

# Create super administrators from yml
super_administrators = Admin::AuthorityGroup::SuperAdmin.initialize_usernames
users_to_authorize = super_administrators.map {|a| %Q(#{a}) }.join(", ")

super_admin = Admin::AuthorityGroup.create_with(description: 'Authority Control Group', authorized_usernames: users_to_authorize).find_or_create_by(auth_group_name: 'super_admin', controlling_class_name: "Admin::AuthorityGroup::SuperAdmin")

# Create administrators from yml
administrators = Admin::AuthorityGroup::RepositoryAdministrator.initialize_usernames
users_to_authorize = administrators.map {|a| %Q(#{a}) }.join(", ")

administrators.each do |username|
  next if RepoManager.find_by(username: username)
  RepoManager.find_or_create_by!(username: username, active: true)
end

admin = Admin::AuthorityGroup.create_with(description: 'Users with admin access rights', authorized_usernames: users_to_authorize).find_or_create_by(auth_group_name: 'admin', controlling_class_name: "Admin::AuthorityGroup::RepositoryAdministrator")

# Create token managers from yml (formerly etd_managers)
token_managers = Admin::AuthorityGroup::TokenManager.initialize_usernames
users_to_authorize = token_managers.map {|a| %Q(#{a}) }.join(", ")

token_managers = Admin::AuthorityGroup.create_with(description: 'Users with full rights to manage limited access tokens', authorized_usernames: users_to_authorize).find_or_create_by(auth_group_name: 'token_managers', controlling_class_name: "Admin::AuthorityGroup::TokenManager")

# Create group for users who can view all without edit rights
view_all_works_users = Admin::AuthorityGroup::ViewAll.initialize_usernames
users_to_authorize = view_all_works_users.map {|a| %Q(#{a}) }.join(", ")

view_all = Admin::AuthorityGroup.create_with(description: 'Users who can see but not touch things they do not own', authorized_usernames: users_to_authorize).find_or_create_by(auth_group_name: 'view_all', controlling_class_name: "Admin::AuthorityGroup::ViewAll")
