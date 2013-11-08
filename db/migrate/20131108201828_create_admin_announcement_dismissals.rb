class CreateAdminAnnouncementDismissals < ActiveRecord::Migration
  def change
    create_table :admin_announcement_dismissals do |t|
      t.belongs_to :user
      t.belongs_to :admin_announcement
      t.timestamps
    end

    add_index :admin_announcement_dismissals, :user_id
    add_index :admin_announcement_dismissals, :admin_announcement_id
    add_index :admin_announcement_dismissals, [:user_id, :admin_announcement_id], name: [:admin_announcement_dismissals_join_index]
  end
end
