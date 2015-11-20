class AddExpiryDateToTemporaryAccessToken < ActiveRecord::Migration
  def self.up
    remove_index :temporary_access_tokens, :used
    remove_index :temporary_access_tokens, [:sha, :noid, :used]
    remove_column :temporary_access_tokens, :used

    add_column :temporary_access_tokens, :expiry_date, :datetime, null: true
    add_index :temporary_access_tokens, :expiry_date
    add_index :temporary_access_tokens, [:sha, :noid, :expiry_date], unique: true
  end

  def self.down
    remove_index :temporary_access_tokens, :expiry_date
    remove_index :temporary_access_tokens, [:sha, :noid, :expiry_date]
    remove_column :temporary_access_tokens, :expiry_date

    add_column :temporary_access_tokens, :used, :boolean, default: false
    add_index :temporary_access_tokens, :used
    add_index :temporary_access_tokens, [:sha, :noid, :used], unique: true
  end
end
