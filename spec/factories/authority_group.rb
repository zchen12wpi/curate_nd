# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :super_admin_grp, :class => Admin::AuthorityGroup do
    auth_group_name { Admin::AuthorityGroup::SuperAdmin::AUTH_GROUP_NAME }
    description { 'Super admin group' }
    controlling_class_name { 'Admin::AuthorityGroup::SuperAdmin' }
    authorized_usernames { Admin::AuthorityGroup::SuperAdmin.initialize_usernames.map {|a| %Q(#{a}) }.join(", ") }
    created_at { Date.today }
    updated_at { Date.today }
  end

  factory :admin_grp, :class => Admin::AuthorityGroup do
    auth_group_name { Admin::AuthorityGroup::RepositoryAdministrator::AUTH_GROUP_NAME }
    description { 'Admin group' }
    controlling_class_name { 'Admin::AuthorityGroup::RepositoryAdministrator' }
    authorized_usernames { Admin::AuthorityGroup::RepositoryAdministrator.initialize_usernames.map {|a| %Q(#{a}) }.join(", ") }
    created_at { Date.today }
    updated_at { Date.today }
  end

  factory :token_managers, :class => Admin::AuthorityGroup do
    auth_group_name { Admin::AuthorityGroup::TokenManager::AUTH_GROUP_NAME }
    description { 'Time-limited token manager' }
    controlling_class_name { 'Admin::AuthorityGroup::TokenManager' }
    authorized_usernames { Admin::AuthorityGroup::TokenManager.initialize_usernames.map {|a| %Q(#{a}) }.join(", ") }
    created_at { Date.today }
    updated_at { Date.today }
  end

  factory :view_only_grp, :class => Admin::AuthorityGroup do
    auth_group_name { Admin::AuthorityGroup::ViewOnly::AUTH_GROUP_NAME }
    description { 'View only admin' }
    controlling_class_name { 'Admin::AuthorityGroup::ViewOnly' }
    authorized_usernames { Admin::AuthorityGroup::ViewOnly.initialize_usernames.map {|a| %Q(#{a}) }.join(", ") }
    created_at { Date.today }
    updated_at { Date.today }
  end
end
