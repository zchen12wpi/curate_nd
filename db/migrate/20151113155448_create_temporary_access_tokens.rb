class CreateTemporaryAccessTokens < ActiveRecord::Migration
  def change
    create_table :temporary_access_tokens do |t|
      t.string :sha
      t.string :noid
      t.string :issued_by
      t.boolean :used

      t.timestamps
    end
    add_index :temporary_access_tokens, :sha, unique: true
    add_index :temporary_access_tokens, :noid
    add_index :temporary_access_tokens, :used
  end
end
