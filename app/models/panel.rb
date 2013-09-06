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
    #TODO still not working
    #tests for floating point numbers as well
    #numericality: { only_integer: true }
    format: { with: /\A\d+\.?\d{0,2}\Z/ }
  #prevents form from being submitted
  #validates :pv_query_id, presence: true

  #return hash: vector[:x], [:y], [:z]
  def vector# <<<
    vector = Hash.new
    hypotenuse = Math.cos(self.tilt.to_rad)
    vector[:x] = hypotenuse * Math.cos(self.bearing.to_rad)
    vector[:y] = hypotenuse * Math.sin(self.bearing.to_rad)
    vector[:z] = Math.sin(self.tilt.to_rad)
    return vector
  end# >>>
  #return input (Watts/sqm) for one hr from direct normal irradiance (dni)
  def hourly_direct_input(hourly_dni)# <<<
    input = hourly_dni * Math.cos(self.relative_angle())
  end# >>>
  #return output of solar panel (KWh)
  def hourly_output# <<<
    output = self.hourly_direct_input(dni)
  end# >>>
  #return hash of hourly Direct Normal Insolation received by panel for whole year (KWh/sqm)
  #{ day1: [KWh1, KWh2...]... }
  #0 KWh values must be included so that time can be calculated from position in
  #array
  def annual_dni_received(annual_dni)# <<<
    received_input = Hash.new
    #TODO
    #how to get PvQuery.longitude?
    #pass in as argument
    latitude = -20
    longitude = 130
    sun = Sun.new(latitude, longitude, 1)
    365.times do |d|
      sun.day = d
      received_input[d] = Array.new
      #assume 5am is the Eastern Standard Time of first value
      dni_time = 5
      #time_correction = sun.time_correction
      annual_dni[d].each do |hourly_dni|
        if hourly_dni == 0
          #pad with 0 values so that time can be deduced
          received_input[d] << 0
        else
          #TODO refactor
          lst = sun.to_lst(dni_time)
          hra = sun.hra(lst)
          sun_vector = sun.vector(hra)
          received_input[d] << self.relative_angle(sun_vector) * hourly_dni
        end
        dni_time = dni_time + 1
      end
    end
    return received_input
  end# >>>
  private
    #return angle of incident light relative to panel in radians (where 0 is
    #directly perpendicular to panel surface)
    def relative_angle(sun_vector)# <<<
      angle = Math.acos((self.vector[:x] * sun_vector[:x] + self.vector[:x] * sun_vector[:x] + self.vector[:x] * sun_vector[:x]) / (Math.sqrt(Math.power(self.vector[:x]) + Math.power(self.vector[:y]) + Math.power(self.vector[:z])) + Math.sqrt(Math.power(sun_vector[:x]) + Math.power(sun_vector[:y]) + Math.power(sun_vector[:z]))))
    end# >>>
end
