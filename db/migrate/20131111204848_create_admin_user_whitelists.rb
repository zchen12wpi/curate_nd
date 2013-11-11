class CreateAdminUserWhitelists < ActiveRecord::Migration
  def change
    create_table :admin_user_whitelists, force: true do |t|
      t.string :username

      t.timestamps
    end
    add_index :admin_user_whitelists, :username, unique: true
  end
end
