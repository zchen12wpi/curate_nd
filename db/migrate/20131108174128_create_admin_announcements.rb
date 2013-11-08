class CreateAdminAnnouncements < ActiveRecord::Migration
  def change
    create_table :admin_announcements do |t|
      t.text :message
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps
    end
    add_index :admin_announcements, :start_at
    add_index :admin_announcements, :end_at
    add_index :admin_announcements, [:start_at, :end_at], name: [:admin_announcements_for_index]
  end
end
