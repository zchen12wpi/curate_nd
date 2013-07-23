# This migration comes from activity_engine (originally 20130722162331)
class CreateActivityEngineActivities < ActiveRecord::Migration
  def change
    create_table :activity_engine_activities do |t|
      t.integer :user_id
      t.string :subject_type, index: true, null: false
      t.string :subject_id, index: true, null: false
      t.string :activity_type, index: true, null: false
      t.text :message
      t.timestamps
    end
    add_index :activity_engine_activities, :user_id
  end
end
