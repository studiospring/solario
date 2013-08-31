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
  #return angle of incident light relative to panel in radians (where 0 is
  #directly perpendicular to panel surface)
  def relative_angle(sun_vector)# <<<
    angle = Math.acos((self.vector[:x] * sun_vector[:x] + self.vector[:x] * sun_vector[:x] + self.vector[:x] * sun_vector[:x]) / (Math.sqrt(Math.power(self.vector[:x]) + Math.power(self.vector[:y]) + Math.power(self.vector[:z])) + Math.sqrt(Math.power(sun_vector[:x]) + Math.power(sun_vector[:y]) + Math.power(sun_vector[:z]))))
  end# >>>
  #return input (Watts/sqm) for one hr from direct normal irradiance (dni)
  def hourly_direct_input(hourly_dni)# <<<
    input = hourly_dni * Math.cos(self.relative_angle())
  end# >>>
  #return output of solar panel (KWh)
  def hourly_output# <<<
    output = self.hourly_direct_input(dni)
  end# >>>
end
