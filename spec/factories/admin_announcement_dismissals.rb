# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :admin_announcement_dismissal, :class => 'Admin::AnnouncementDismissal' do
    user_id 1
  end
end
