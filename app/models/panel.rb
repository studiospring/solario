# == Schema Information
#
# Table name: panels
#
#  id          :integer          not null, primary key
#  tilt        :integer
#  bearing     :integer
#  panel_size  :decimal(, )
#  pv_query_id :integer
#

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
                          inclusion: {:in => 1..500}

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
  #0 KWh values must be included so that time can be calculated from position in array
  #dni_pa is irradiances.direct ( string )
  def dni_received_pa(dni_pa)# <<<
    #set annual increment here
    annual_increment = 12
    days_in_increment = (365 / annual_increment).round
    annual_dni_hash = dni_pa.data_string_to_hash(annual_increment)
    latitude = self.pv_query.postcode.latitude
    longitude = self.pv_query.postcode.longitude
    sun = Sun.new(latitude, longitude, 1)
    #use this for dummy data (only, at present)
    annual_dni_hash.each do |key, diurnal_dni|
      #assume 6am is the Universal Time of first value
      dni_time = 6
      panel_insolation = Array.new
      diurnal_dni.collect do |dni|
        lst = sun.to_lst(dni_time)
        hra = sun.hra(lst)
        sun_vector = sun.vector(hra)
        relative_angle = self.relative_angle(sun_vector)
        panel_insolation << (self.panel_insolation(dni, relative_angle) * self.panel_size).round(2)
        #set daily increment here
        dni_time = dni_time + 3
      end
      annual_dni_hash[key] = panel_insolation
      #increment sun's day so that sun vector is correct
      sun.day = sun.day + days_in_increment
    end
    return annual_dni_hash
  end# >>>
  #return hash of hourly diffuse insolation received by panel for whole year (KWh/sqm)
  #{ day1: [KWh1, KWh2...]... }
  #0 KWh values must be included so that time can be calculated from position in array
  def diffuse_received_pa# <<<
    #TODO
  end# >>>
  #currently not in use
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
  def avg_annual_output(dni_received_pa, diffuse_received_pa)# <<<
    lifespan = 20
    total_dni = Panel.annual_received_total(dni_received_pa)
    total_diffuse = Panel.annual_received_total(diffuse_received_pa)
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
      angle = Math.acos((panel_vector[:x] * sun_vector[:x] + panel_vector[:y] * sun_vector[:y] + panel_vector[:z] * sun_vector[:z]) / (Math.sqrt(panel_vector[:x]**2 + panel_vector[:y]**2 + panel_vector[:z]**2) + Math.sqrt(sun_vector[:x]**2 + sun_vector[:y]**2 + sun_vector[:z]**2))).round(2)
    end# >>>
    #return insolation received by 1sqm module via vector method
    #S_module = S_incident * cos(relative_angle)
    def panel_insolation(incident_light, relative_angle)# <<<
      #calculate only if relative angle <= 90 degrees, else return 0
      if relative_angle <= 1.57
        insolation_received = (incident_light * Math.cos(relative_angle)).round(2)      
      else
        insolation_received = 0
      end
      return insolation_received
    end# >>>
end
