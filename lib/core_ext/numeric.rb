#To use:
#require 'core_ext/numeric'
class Numeric
  #convert degrees to radians. eg 45.degrees => 1.0
  def to_rad
    self * Math::PI / 180 
  end
end
