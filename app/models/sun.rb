class Sun
  include SolarTime
  require 'core_ext/numeric'
  attr_accessor :latitude, :longitude, :state, :day, :local_time

  # @arg [Fixnum], [Fixnum], [String]
  # @arg [Fixnum] day is [1..365].
  # @arg [Fixnum] local_time is decimal time in 24hr time, eg 13.5 is 13:30pm.
  def initialize(latitude, longitude, state, day, local_time)
    @latitude = latitude
    @longitude = longitude
    @state = state
    @day = day
    @local_time = local_time
  end

  # Converts azimuth and elevation in to vector notation:
  # S = Sx + Sy + Sz
  # @return [Hash] vector[:x], [:y], [:z].
  def vector
    elev = elevation
    az = azimuth
    hypotenuse = Math.cos(elev)
    {
      :x => hypotenuse * Math.cos(az),
      :y => hypotenuse * Math.sin(az),
      :z => Math.sin(elev),
    }
  end

  # @return [Float] declination in radians.
  def declination
    Math.asin(0.3979486313076103 * Math.sin(0.017214206 * (day - 81))).abs
  end

  # Input hra in degrees bc degs is easier to understand.
  # @return [Float] elevation of sun in radians.
  def elevation
    Math.asin(elevation_formula)
  end

  # Input hra in degrees bc degs is easier to understand.
  # @return [Float] azimuth in radians.
  def azimuth
    case
    when hra > 0
      360.to_rad - azimuth_formula
    when hra == 0
      0
    else
      azimuth_formula
    end
  end

  protected

  def elevation_formula
    dec = declination
    lat = latitude.to_rad
    Math.sin(dec) * Math.sin(lat) + Math.cos(dec) * Math.cos(lat) *
      Math.cos(hra_in_radians)
  end

  def azimuth_formula
    Math.acos(azimuth_add - azimuth_subtract)
  end

  def azimuth_add
    Math.sin(declination) * Math.cos(latitude.to_rad)
  end

  def azimuth_subtract
    Math.cos(declination) * Math.sin(latitude.to_rad) * Math.cos(hra_in_radians) /
      Math.cos(elevation)
  end
end
