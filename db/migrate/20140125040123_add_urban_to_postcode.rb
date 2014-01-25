class AddUrbanToPostcode < ActiveRecord::Migration
  def change
    add_column :postcodes, :urban, :boolean, default: false
  end
end
