class SolarTime
  require 'core_ext/numeric'
  attr_accessor :longitude

  def initialize(longitude)
    @longitude = longitude
  end
    #refactor 'B' variable used in EoT and declination methods
    #return radians
    def b(day)# <<<
      b = (360 / 365.0)*(day - 81).to_rad
    end# >>>
    #return Equation of Time in minutes
    def eot(day)# <<<
      b = self.b(day)
      eot = 9.87 * Math.sin(2 * b) - 7.53 * Math.cos(b) - 1.5 * Math.sin(b)
    end# >>>

  #return minutes by which local time should be corrected, to account for
  #position and day of year
  def time_correction(day)# <<<
    #assume solar measurements are taken at EST (GMT/UTC + 10)
    #therefore lstm is 15 * 10
    lstm = 150
    time_correction = 4 * (self.longitude - lstm) + self.eot(day)
  end# >>>
  #convert local hour to local solar time in decimal notation
  #insert 24hr hourly time: 9, 12, 13 ...
  #and 13.5 is returned for 13:30pm
  def to_lst(local_hour, time_correction)# <<<
    lst = local_hour + (time_correction / 60)
  end# >>>
  
end
