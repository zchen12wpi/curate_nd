class AddIndexToWhitelist < ActiveRecord::Migration
  def change
    add_index :user_whitelists, :username, unique: true
  end
end
