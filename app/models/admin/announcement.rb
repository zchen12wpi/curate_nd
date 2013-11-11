class Admin::Announcement < ActiveRecord::Base
  default_scope( {:order => "#{quoted_table_name}.start_at DESC"} )

  has_many :dismissals, class_name: 'Admin::AnnouncementDismissal', dependent: :destroy, foreign_key: :admin_announcement_id

  validates :message, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true

  def to_s; message.to_s; end

  after_commit :remove_dismissals, on: :update

  def self.for(user, as_of = Time.zone.now)
    if user.to_param.blank?
      current(as_of)
    else
      current(as_of).not_dismissed(user)
    end
  end

  def self.not_dismissed(user)
    if user.to_param.blank?
      all
    else
      distinct.
      joins("LEFT OUTER JOIN admin_announcement_dismissals ON admin_announcement_dismissals.admin_announcement_id = admin_announcements.id").
      where("admin_announcement_dismissals.admin_announcement_id IS NULL AND (admin_announcement_dismissals.user_id IS NULL OR admin_announcement_dismissals.user_id != :user_id)", user_id: user.to_param)
    end
  end

  def self.current(as_of = Time.zone.now)
    where("start_at <= :as_of AND end_at >= :as_of", as_of: as_of)
  end

  def self.dismiss(announcement_id, user)
    return true if user.to_param.blank?
    Admin::AnnouncementDismissal.create(admin_announcement_id: announcement_id, user_id: user.to_param)
    true
  end

  private
  def remove_dismissals
    dismissals.destroy_all
  end

end
