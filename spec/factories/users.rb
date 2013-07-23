# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:username) {|n| "username-#{n}" }
    agreed_to_terms_of_service true
    user_does_not_require_profile_update true
  end
end
