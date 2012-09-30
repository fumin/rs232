class CreateExternalDevices < ActiveRecord::Migration
  def up
    create_table :external_devices do |t|
      t.integer :instrument_id, null: false
      t.string :device_type, null: false
      t.text :description, null: false
      t.string :status, null: false
      t.timestamp :latest_on_time
      t.timestamp :scheduled_on_time
      t.timestamp :scheduled_off_time
      t.timestamps
    end
    add_index :external_devices, :description, unique: true
    add_index :external_devices, [:instrument_id, :device_type], unique: true
  end

  def down
    drop_table :external_devices
  end
end
