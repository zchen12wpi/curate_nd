class AddIndexToUserRepositoryId < ActiveRecord::Migration
  def change
    add_index :users, :repository_id, unique: true
  end
end
