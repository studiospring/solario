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

  # Convert azimuth and elevation in to vector notation:
  # S = Sx + Sy + Sz
  # @return [Hash] vector[:x], [:y], [:z].
  # Insert 24hr hourly time: 9, 12, 13, eg 13.5 is 13:30pm.
  def vector
    vector = {}
    elev = self.elevation
    az = self.azimuth
    hypotenuse = Math.cos(elev)
    vector[:x] = hypotenuse * Math.cos(az)
    vector[:y] = hypotenuse * Math.sin(az)
    vector[:z] = Math.sin(elev)
    vector
  end

  # @return [Float] declination in radians.
  def declination
    Math.asin(0.3979486313076103 * Math.sin(0.017214206 * (self.day - 81))).abs
  end

  # Input hra in degrees bc degs is easier to understand.
  # @return [Float] elevation of sun in radians.
  def elevation
    dec = self.declination
    lat = self.latitude.to_rad
    Math.asin(Math.sin(dec) * Math.sin(lat) + Math.cos(dec) * Math.cos(lat) * Math.cos(self.hra.to_rad))
  end

  # Input hra in degrees bc degs is easier to understand.
  # @return [Float] azimuth in radians.
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
    azimuth
  end
end
