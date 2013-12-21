class CustomiseUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :username, unique: true
      t.boolean :admin, default: false
    end
  end
end
