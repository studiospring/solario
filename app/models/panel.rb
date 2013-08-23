class Panel < ActiveRecord::Base
  belongs_to :pv_query, dependent: :destroy

  validates :tilt,        presence: true,
                          length: { maximum: 2 },
                          numericality: { greater_than_or_equal_to: 0 },
                          numericality: { less_than_or_equal_to: 90 }
  validates :bearing,     presence: true,
                          length: { maximum: 3 },
                          numericality: { greater_than_or_equal_to: 0 },
                          numericality: { less_than_or_equal_to: 360 }
  validates :panel_size,  presence: true,
                          numericality: { only_integer: true }

end
