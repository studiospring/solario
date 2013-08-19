class ChangePostcodeField < ActiveRecord::Migration
  change_table :postcodes do |t|
    t.rename :postcode, :pcode
  end
end
