class Panel < ActiveRecord::Base
  belongs_to :pv_query, dependent: :destroy
end
