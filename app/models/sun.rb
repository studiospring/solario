class Sun

  require 'core_ext/numeric'
  #return hash: vector[:x], [:y], [:z]
  def vector(azimuth, elevation)# <<<
    vector = Hash.new
    hypotenuse = Math.cos(self.elevation.to_rad)
    vector[:x] = hypotenuse * Math.cos(self.azimuth.to_rad)
    vector[:y] = hypotenuse * Math.sin(self.azimuth.to_rad)
    vector[:z] = Math.sin(self.elevation.to_rad)
    return vector
  end# >>>
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
  #Array of dni values will be per EST hour
  #0 values must be included so that time can be calculated from position in
  #  array
  #see ActiveRecord Serialize
  #{ day1: [val1, val2...], day2: ... }
  def annual_dni# <<<
    #query database
  end# >>>
  private
    #return declination in radians
    def self.declination(day)# <<<
      declination = Math.asin(Math.sin(0.40927970959267024) * Math.sin(0.017214206 * (day - 81))).abs
    end# >>>
    #enter latitude in degrees
    #return hourly elevation in radians for one day
    #[elev1, elev2 ...] 
    #TODO: match elevation times with time when DNI is measured.
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
end
