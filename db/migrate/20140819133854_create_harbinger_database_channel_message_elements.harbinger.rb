# This migration comes from harbinger (originally 20140310185339)
class CreateHarbingerDatabaseChannelMessageElements < ActiveRecord::Migration
  def change
    create_table :harbinger_message_elements do |t|
      t.integer :message_id
      t.string :key
      t.text :value, limit: 2147483647
      t.timestamps
    end
    add_index :harbinger_message_elements, :message_id
    add_index :harbinger_message_elements, :key
    add_index :harbinger_message_elements, [:message_id, :key]
  end
end
