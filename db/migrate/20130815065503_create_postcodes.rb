class CreatePostcodes < ActiveRecord::Migration
  def change
    create_table :postcodes do |t|
      t.integer :postcode
      t.string :suburb
      t.string :state
      t.integer :latitude
      t.integer :longitude

      t.timestamps
    end
  end
end
