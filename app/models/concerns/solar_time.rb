module SolarTime
  require 'core_ext/numeric'
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods# <<<
  end# >>>

  #refactor 'B' variable used in EoT and declination methods
  #return radians
  def b# <<<
    b = (360 / 365.0)*(self.day - 81).to_rad
  end# >>>
  #return Equation of Time in minutes
  def eot# <<<
    b = self.b
    eot = 9.87 * Math.sin(2 * b) - 7.53 * Math.cos(b) - 1.5 * Math.sin(b)
  end# >>>

  #return minutes by which local time should be corrected, to account for
  #position and day of year
  def time_correction# <<<
    #assume solar measurements are taken at EST (GMT/UTC + 10)
    #therefore lstm (local standard time meridian) is 15 * 10
    lstm = 150
    time_correction = 4 * (self.longitude - lstm) + self.eot
  end# >>>
  #convert local hour to local solar time in decimal notation
  #insert 24hr hourly time: 9, 12, 13 ...
  #and 13.5 is returned for 13:30pm
  def to_lst(local_hour)# <<<
    lst = local_hour + (self.time_correction / 60)
  end# >>>
  #return hour angle in degrees
  def hra(lst)# <<<
    hra = 15 * (lst - 12)
  end# >>>
  
end
