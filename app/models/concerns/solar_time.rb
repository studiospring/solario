module SolarTime
  require 'core_ext/numeric'
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
  end

  #refactor 'B' variable used in EoT and declination methods
  #return radians
  def b
    b = (360 / 365.0)*(self.day - 81).to_rad
  end
  #return Equation of Time in minutes
  def eot
    b = self.b
    eot = 9.87 * Math.sin(2 * b) - 7.53 * Math.cos(b) - 1.5 * Math.sin(b)
  end
  #return lstm (local standard time meridian) in degrees (derived from timezone)
  #AEST is (GMT/UTC + 10) therefore lstm (local standard time meridian) is 15 * 10
  #Broken Hill is actually 142.5, Xmas Is, Lord Howe have diff timezones
  #Does not account for DST
  def lstm
    case self.state
      when 'SA', 'NT'
        lstm = 142.5
      when 'WA'
        lstm = 120
      else
        lstm = 150
    end
    return lstm
  end
  #return minutes by which local time should be corrected, to account for
  #position and day of year
  def time_correction
    time_correction = 4 * (self.longitude - self.lstm) + self.eot
  end
  #convert local time to local solar time in decimal notation
  #insert 24hr hourly time: 9, 12, 13 ...
  #and 13.5 is returned for 13:30pm
  def to_lst
    lst = self.local_time + (self.time_correction / 60)
  end
  #return hour angle in degrees
  def hra
    hra = 15 * (self.to_lst - 12)
  end
  
end
