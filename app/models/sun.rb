class Sun
  include SolarTime
  require 'core_ext/numeric'
  attr_accessor :latitude, :longitude, :day

  def initialize(latitude, longitude, day)
    @latitude = latitude
    @longitude = longitude
    @day = day
  end

  #enter latitude in degrees
  #return hourly elevation in radians for every day of year
  #{ day1: [elev1, elev2...], day2: [elev1, elev2..]...}
  def self.annual_elevation(latitude)# <<<
    annual_elev = Hash.new
    (1..365).each do |day|
      annual_elev[day] = self.daily_elevation(day, latitude)
    end
    return annual_elev
  end# >>>
  #return hash of annual direct normal irradiance (KWh/sqm) for specific latitude
  #table (or file) columns will be: latitude longitude dni(KWh/sqm)
  #where dni will be a string to be converted in to a hash
  #Array of dni values will be per UT hour
  #0 values must be included so that time can be calculated from position in
  #  array
  #see ActiveRecord Serialize
  #{ day1: [val1, val2...], day2: ... }
  def annual_dni# <<<
    #query database
  end# >>>
  #return hash: vector[:x], [:y], [:z]
  def vector(hra)# <<<
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
    #enter latitude in degrees
    #return hourly elevation in radians for one day
    #[elev1, elev2 ...] 
    def self.daily_elevation(day, latitude)# <<<
      #hour angle, aka azimuth. 0 is midday at local solar time
      hra = [ 0, 15, 30, 45, 60, 75, 90, 105, 120, 135 ]
      declination = self.declination(day)
      latitude = latitude.to_rad
      pm_elev = Array.new
      hra.each do |angle|
        elevation = Math.asin(Math.sin(declination)*Math.sin(latitude) + Math.cos(declination)*Math.cos(latitude)*Math.cos(angle.to_rad))
        elevation >= 0 ? pm_elev << elevation : break
      end
      daily_elev = Array.new
      daily_elev = pm_elev.drop(1).reverse + pm_elev
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
