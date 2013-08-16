class RemoveTimestampsFromPostcodes < ActiveRecord::Migration
  def change
    remove_timestamps :postcodes
  end
end
