class CreatePanels < ActiveRecord::Migration
  def change
    create_table :panels do |t|
      t.integer :tilt
      t.integer :bearing
      t.decimal :panel_size

      t.timestamps
    end
  end
end
