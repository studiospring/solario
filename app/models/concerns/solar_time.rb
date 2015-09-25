module SolarTime
  require 'core_ext/numeric'

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
  end

  # TODO: refactor 'B' variable used in EoT and declination methods.
  # @return [Float] radians.
  def b
    (360 / 365.0) * (self.day - 81).to_rad
  end

  # @return [Float] Equation of Time in minutes.
  def eot
    b = self.b
    9.87 * Math.sin(2 * b) - 7.53 * Math.cos(b) - 1.5 * Math.sin(b)
  end

  # @return [Float] lstm (local standard time meridian) in degrees (derived from timezone).
  # AEST is (GMT/UTC + 10) therefore lstm (local standard time meridian) is 15 * 10.
  # Broken Hill is actually 142.5, Xmas Is, Lord Howe have diff timezones.
  # Does not account for DST.
  def lstm
    case self.state
    when 'SA', 'NT'
      lstm = 142.5
    when 'WA'
      lstm = 120
    else
      lstm = 150
    end
    lstm
  end

  # @return [Float] minutes by which local time should be corrected, to account for
  #   position and day of year.
  def time_correction
    4 * (self.longitude - self.lstm) + self.eot
  end

  # @return [Float] local solar time in decimal notation from local time
  #   eg 13.5 is returned for 13:30pm.
  def to_lst
    self.local_time + (self.time_correction / 60)
  end

  # @return hour angle [Float] in degrees.
  def hra
    15 * (self.to_lst - 12)
  end

  def hra_in_radians
    self.hra.to_rad
  end
end
