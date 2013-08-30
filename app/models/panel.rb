class Panel < ActiveRecord::Base
  require 'core_ext/numeric'

  belongs_to :pv_query

  validates :tilt,        presence: true,
                          length: { maximum: 2 },
                          numericality: { greater_than_or_equal_to: 0,
                                          less_than_or_equal_to: 90 }
  validates :bearing,     presence: true,
                          length: { maximum: 3 },
                          numericality: { greater_than_or_equal_to: 0, 
                                          less_than_or_equal_to: 360 }
  validates :panel_size,  presence: true,
                          format: { with: /^\d+\.?\d{0,2}$/,
                                    multiline: true }
  validates :pv_query_id, presence: true

  #return hash: vector[:x], [:y], [:z]
  def vector# <<<
    vector = Hash.new
    hypotenuse = Math.cos(self.tilt.to_rad)
    vector[:x] = hypotenuse * Math.cos(self.bearing.to_rad)
    vector[:y] = hypotenuse * Math.sin(self.bearing.to_rad)
    vector[:z] = Math.sin(self.tilt.to_rad)
    return vector
  end# >>>
end
