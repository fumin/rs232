class CreateCoordinators < ActiveRecord::Migration
  def up
    create_table :coordinators do |t|
      t.binary :pan_id, null: false
      t.binary :mac_address, null: false
      t.boolean :line_status, null: false
      t.text :description, null: false
      t.timestamps
    end
  end
  add_index :coordinators, :mac_address, unique: true
  add_index :coordinators, :description, unique: true
  add_index :coordinators, :pan_id, unique: true

  def down
    drop_table :coordinators
  end
end
