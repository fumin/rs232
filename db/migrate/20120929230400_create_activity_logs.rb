class CreateActivityLogs < ActiveRecord::Migration
  def up
    create_table :activity_logs do |t|
      t.binary :mac_address, null: false
      t.timestamp :on_time, null: false
      t.timestamp :off_time, null: false

      t.timestamps
    end
    add_index :activity_logs, [:mac_address]
  end

  def down
    drop_table :activity_logs
  end
end
