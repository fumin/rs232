class CreateInstruments < ActiveRecord::Migration
  def up
    create_table :instruments do |t|
      t.integer :coordinator_id, null: false
      t.boolean :line_status, null: false
      t.integer :parent_id
      t.string :room, null: false
      t.binary :mac_address , null: false

      t.timestamps
    end
    add_index :instruments, :mac_address, unique: true
  end

  def down
    drop_table :instruments
  end
end
