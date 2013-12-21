class AddForeignKey < ActiveRecord::Migration
  change_table :pv_queries do |t|
    t.remove :postcode
    t.integer :postcode_id
  end
end
