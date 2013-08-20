class CreatePostcodes < ActiveRecord::Migration
  def change
    create_table :postcodes do |t|
      t.integer :pcode
      t.string :suburb
      t.string :state
      t.decimal :latitude
      t.decimal :longitude
    end
  end
end
