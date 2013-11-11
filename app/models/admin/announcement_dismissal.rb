class Admin::AnnouncementDismissal < ActiveRecord::Base
  belongs_to :user
  belongs_to :admin_announcement, class_name: 'Admin::Announcement'
end
