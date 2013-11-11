# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :admin_user_whitelist, :class => 'Admin::UserWhitelist' do
    username "MyString"
  end
end
