class Sun
  include SolarTime
  require 'core_ext/numeric'
  attr_accessor :latitude, :longitude, :state, :day, :local_time

  def initialize(latitude, longitude, state, day, local_time)
    @latitude = latitude
    @longitude = longitude
    @state = state
    @day = day
    @local_time = local_time
  end

  #convert azimuth and elevation in to vector notation:
  #S = Sx + Sy + Sz
  #return hash: vector[:x], [:y], [:z]
  #insert 24hr hourly time: 9, 12, 13 ...
  #eg 13.5 is 13:30pm
  def vector
    lst = self.to_lst
    hra = self.hra
    vector = Hash.new
    elev = self.elevation
    az = self.azimuth
    hypotenuse = Math.cos(elev)
    vector[:x] = hypotenuse * Math.cos(az)
    vector[:y] = hypotenuse * Math.sin(az)
    vector[:z] = Math.sin(elev)
    return vector
  end
  #return declination in radians
  def declination
    declination = Math.asin(0.3979486313076103 * Math.sin(0.017214206 * (self.day - 81))).abs
  end
  #input hra in degrees bc degs is easier to understand
  #return elevation of sun in radians
  def elevation
    dec = self.declination
    lat = self.latitude.to_rad
    elevation = Math.asin(Math.sin(dec) * Math.sin(lat) + Math.cos(dec) * Math.cos(lat) * Math.cos(self.hra.to_rad))
  end
  #input hra in degrees bc degs is easier to understand
  #return azimuth in radians
  def azimuth
    dec = self.declination
    lat = self.latitude.to_rad
    hra = self.hra.to_rad
    azimuth = Math.acos((Math.sin(dec) * Math.cos(lat) - Math.cos(dec) * Math.sin(lat) * Math.cos(hra) / Math.cos(self.elevation)))
    if self.hra > 0
      azimuth = 360.to_rad - azimuth
    elsif self.hra == 0
      azimuth = 0
    end
    return azimuth
  end
end
