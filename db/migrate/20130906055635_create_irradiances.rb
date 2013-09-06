class CreateIrradiances < ActiveRecord::Migration
  def change
    create_table :irradiances do |t|
      t.text :direct
      t.text :diffuse
      t.integer :postcode_id

      t.timestamps
    end

    add_index :irradiances, postcode_id
  end
end
