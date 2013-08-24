class Add < ActiveRecord::Migration
  def change
    add_column :panels, :pv_query_id, :integer
    add_index :panels, :pv_query_id
  end
end
