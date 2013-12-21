class CreatePvQueries < ActiveRecord::Migration
  def change
    create_table :pv_queries do |t|
      t.integer :postcode

      t.timestamps
    end
  end
end
