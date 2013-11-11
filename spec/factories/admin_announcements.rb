# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :admin_announcement, :class => 'Admin::Announcement' do
    message "MyText"
    start_at 1.day.ago
    end_at 1.day.from_now
  end
end
