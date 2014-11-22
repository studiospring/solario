#To use:
#require 'core_ext/numeric'
class Numeric
  #convert degrees to radians. eg 45.degrees => 1.0
  def to_rad
    self * Math::PI / 180 
  end
  #return difference in degrees from north
  def deg_to_north
    deg = 180 - ((360 - self).abs - 180).abs
  end
end
