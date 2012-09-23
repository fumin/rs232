class CreateInstruments < ActiveRecord::Migration
  def up
    create_table :instruments do |t|
      t.string :room, null: false
      t.binary :mac_address , null: false
      t.text :description
      t.string :status, null: false

      t.timestamps
    end
    add_index :instruments, :mac_address, unique: true
  end

  def down
    drop_table :instruments
  end
end
