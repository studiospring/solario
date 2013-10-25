class Sun
  include SolarTime
  require 'core_ext/numeric'
  attr_accessor :latitude, :longitude, :state, :day

  def initialize(latitude, longitude, state, day)
    @latitude = latitude
    @longitude = longitude
    @state = state
    @day = day
  end

  #convert azimuth and elevation in to vector notation:
  #S = Sx + Sy + Sz
  #return hash: vector[:x], [:y], [:z]
  #insert 24hr hourly time: 9, 12, 13 ...
  #eg 13.5 is 13:30pm
  def vector(local_hour)# <<<
    lst = self.to_lst(local_hour)
    hra = self.hra(lst)
    vector = Hash.new
    elev = self.elevation(hra)
    az = self.azimuth(hra)
    hypotenuse = Math.cos(elev)
    vector[:x] = hypotenuse * Math.cos(az)
    vector[:y] = hypotenuse * Math.sin(az)
    vector[:z] = Math.sin(elev)
    return vector
  end# >>>
  #private
    #return declination in radians
    def declination# <<<
      declination = Math.asin(0.3979486313076103 * Math.sin(0.017214206 * (self.day - 81))).abs
    end# >>>
    #input hra in degrees bc degs is easier to understand
    #return elevation of sun in radians
    def elevation(hra)# <<<
      dec = self.declination
      lat = self.latitude.to_rad
      elevation = Math.asin(Math.sin(dec) * Math.sin(lat) + Math.cos(dec) * Math.cos(lat) * Math.cos(hra.to_rad))
    end# >>>
    #input hra in degrees bc degs is easier to understand
    #return azimuth in radians
    def azimuth(hra)# <<<
      dec = self.declination
      lat = self.latitude.to_rad
      azimuth = Math.acos((Math.sin(dec) * Math.cos(lat) - Math.cos(dec) * Math.sin(lat) * Math.cos(hra.to_rad) / Math.cos(self.elevation(hra))))
    end# >>>
end
