class PvQuery < ActiveRecord::Base
  require 'core_ext/numeric'

  has_many :panels, dependent: :destroy
  accepts_nested_attributes_for :panels#, reject_if: lambda { |a| a[:tilt].blank? }

  validates :postcode,  presence: true,
                        length: { maximum: 4 },
                        numericality: { only_integer: true }

  #return declination in radians
  def self.declination(day)# <<<
    declination = Math.asin(Math.sin(0.40927970959267024) * Math.sin(0.017214206 * (day - 81))).abs
  end# >>>
  #enter latitude in degrees
  #return elevation in radians for one day
  #[elev1, elev2 ...] 
  def self.daily_elevation(day, latitude)# <<<
    #hour angle, 0 is midday at local solar time
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
  #return hourly elevation for every day of year
  #{ day1: [elev1, elev2...], day2: [elev1, elev2..]...}
  def self.annual_elevation(latitude)# <<<
    declination = 
    annual_elev = Hash.new
    declination.each do |d|
      day = declination.index(d) + 1
      annual_elev[day] = self.daily_elev(d, latitude)
    end
    return annual_elev
  end# >>>
end
