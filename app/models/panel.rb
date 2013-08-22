class Panel < ActiveRecord::Base
  belongs_to :pv_query, dependent: :destroy

  validates :tilt,        presence: true,
                          length: { maximum: 2 },
                          numericality: { only_integer: true }
  validates :bearing,     presence: true,
                          length: { maximum: 3 },
                          numericality: { only_integer: true }
  validates :panel_size,  presence: true

end
