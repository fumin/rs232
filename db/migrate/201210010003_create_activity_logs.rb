class CreateActivityLogs < ActiveRecord::Migration
  def up
    create_table :activity_logs do |t|
      t.text :description, null: false
      t.integer :external_device_id, null: false
      t.timestamp :on_time, null: false
      t.timestamp :off_time, null: false

      t.timestamps
    end
    add_index :activity_logs, :external_device_id
    add_index :activity_logs, :description
  end

  def down
    drop_table :activity_logs
  end
end
