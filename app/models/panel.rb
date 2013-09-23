class Panel < ActiveRecord::Base
  require 'core_ext/numeric'
  require 'core_ext/string'

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
  #no longer necessary?
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
  #annual_dni is irradiances.direct string
  def annual_dni_received(annual_dni)# <<<
    annual_dni = annual_dni.data_string_to_hash(12, 5)
    #received_input = Hash.new
    #TODO
    #how to get PvQuery.longitude?
    #pass in as argument
    latitude = -20
    longitude = 130
    sun = Sun.new(latitude, longitude, 1)
    #use this for dummy data (only, at present)
    annual_dni.each do |key, daily_dni|
      #assume 6am is the Universal Time of first value
      dni_time = 6
      daily_dni.map do |dni|
        #TODO refactor
        lst = sun.to_lst(dni_time)
        hra = sun.hra(lst)
        sun_vector = sun.vector(hra)
        dni * self.relative_angle(sun_vector)
        dni_time = dni_time + 3
      end
    end
    #12.times do |m|# <<<
      #months = %w{jan feb mar apr may jun jul aug sep oct nov dec}
      #month = months[m - 1]
      #sun.month = month
      #received_input[month] = Array.new
      ##assume 6am is the Universal Time of first value
      #dni_time = 6
      ##time_correction = sun.time_correction
      #annual_dni[m].each do |hourly_dni|
        #if hourly_dni == 0
          ##pad with 0 values so that time can be deduced
          #received_input[month] << 0
        #else
          ##TODO refactor
          #lst = sun.to_lst(dni_time)
          #hra = sun.hra(lst)
          #sun_vector = sun.vector(hra)
          #received_input[month] << self.relative_angle(sun_vector) * hourly_dni
        #end
        #dni_time = dni_time + 3
      #end
    #end# >>>
    #obsolete because dummy values are fewer
    #may use in future
    #365.times do |d|# <<<
      #sun.day = d
      #received_input[d] = Array.new
      ##assume 5am is the Eastern Standard Time of first value
      #dni_time = 5
      ##time_correction = sun.time_correction
      #annual_dni[d].each do |hourly_dni|
        #if hourly_dni == 0
          ##pad with 0 values so that time can be deduced
          #received_input[d] << 0
        #else
          ##TODO refactor
          #lst = sun.to_lst(dni_time)
          #hra = sun.hra(lst)
          #sun_vector = sun.vector(hra)
          #received_input[d] << self.relative_angle(sun_vector) * hourly_dni
        #end
        #dni_time = dni_time + 1
      #end
    #end# >>>
    return annual_dni
  end# >>>
  #return hash of hourly diffuse insolation received by panel for whole year (KWh/sqm)
  #{ day1: [KWh1, KWh2...]... }
  #0 KWh values must be included so that time can be calculated from position in
  #array
  def annual_diffuse_received# <<<
    #TODO
  end# >>>
  #add annual insolation hash to return total energy received
  def self.annual_received_total(annual_received_hash)# <<<
    annual_total = 0
    annual_received_hash. each do |day, hourly_dni|
      #add array
      daily_total = hourly_dni.inject(:+)
      annual_total = annual_total + daily_total
    end
    return annual_total
  end# >>>
  #currently not in use
  #efficiency must have 0 in front! eg 0.99
  def self.average_efficiency(lifespan, efficiency)# <<<
    total = 0
    (1...lifespan).times do |year|
      total = total + efficiency ** year
    end
    avg = total / lifespan
  end# >>>
  #return KW/yr? taking in to account compound depreciated inefficiency, age of panel, etc
  def avg_annual_output(annual_dni_received, annual_diffuse_received)# <<<
    lifespan = 20
    total_dni = Panel.annual_received_total(annual_dni_received)
    total_diffuse = Panel.annual_received_total(annual_diffuse_received)
    annual_input = total_dni + total_diffuse
    #assume compound efficiency of 99%pa
    average_efficiency = 0.9
    annual_output = annual_input * average_efficiency
  end# >>>
  #private
    #return angle of incident light relative to panel in radians (where 0 is
    #directly perpendicular to panel surface)
    def relative_angle(sun_vector)# <<<
      panel_vector = self.vector
      angle = Math.acos((panel_vector[:x] * sun_vector[:x] + panel_vector[:x] * sun_vector[:x] + panel_vector[:x] * sun_vector[:x]) / (Math.sqrt(panel_vector[:x] ** 2 + panel_vector[:y] ** 2 + panel_vector[:z] ** 2) + Math.sqrt(sun_vector[:x] ** 2 + sun_vector[:y] ** 2 + sun_vector[:z] ** 2)))
    end# >>>
end
