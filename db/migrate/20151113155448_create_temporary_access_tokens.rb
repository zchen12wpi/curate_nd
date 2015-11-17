class CreateTemporaryAccessTokens < ActiveRecord::Migration
  def change
    create_table :temporary_access_tokens, id: false, primary_key: :sha do |t|
      t.string :sha, null: false
      t.string :noid
      t.string :issued_by
      t.boolean :used, default: false

      t.timestamps
    end
    add_index :temporary_access_tokens, :sha, unique: true
    add_index :temporary_access_tokens, :noid
    add_index :temporary_access_tokens, :used
    add_index :temporary_access_tokens, [:sha, :noid, :used], unique: true
  end
end
