class PvQuery < ActiveRecord::Base
  require 'core_ext/numeric'

  has_many :panels, dependent: :destroy
  accepts_nested_attributes_for :panels#, reject_if: lambda { |a| a[:tilt].blank? }

  validates :postcode,  presence: true,
                        length: { maximum: 4 },
                        numericality: { only_integer: true }

  #return array
  def declination# <<<
    declination = [ 23.0064928292,
                    22.9250204422,
                    22.8367660843,
                    22.7417558642,
                    22.6400178888,
                    22.5315822556,
                    22.4164810435,
                    22.2947483032,
                    22.1664200471,
                    22.0315342389,
                    21.8901307824,
                    21.7422515092,
                    21.5879401669,
                    21.4272424058,
                    21.2602057656,
                    21.0868796612,
                    20.9073153682,
                    20.7215660074,
                    20.5296865296,
                    20.3317336992,
                    20.1277660769,
                    19.9178440031,
                    19.7020295796,
                    19.4803866514,
                    19.2529807876,
                    19.0198792625,
                    18.781151035,
                    18.5368667287,
                    18.287098611,
                    18.0319205714,
                    17.7714080999,
                    17.5056382647,
                    17.2346896891,
                    16.9586425286,
                    16.677578447,
                    16.3915805923,
                    16.1007335718,
                    15.8051234278,
                    15.5048376114,
                    15.1999649568,
                    14.8905956555,
                    14.576821229,
                    14.258734502,
                    13.936429575,
                    13.6100017963,
                    13.2795477339,
                    12.945165147,
                    12.6069529568,
                    12.2650112177,
                    11.919441087,
                    11.5703447959,
                    11.2178256183,
                    10.861987841,
                    10.5029367324,
                    10.1407785117,
                    9.775620317,
                    9.407570174,
                    9.0367369642,
                    8.6632303919,
                    8.2871609528,
                    7.9086399004,
                    7.5277792137,
                    7.1446915637,
                    6.7594902802,
                    6.3722893184,
                    5.983203225,
                    5.5923471045,
                    5.1998365847,
                    4.8057877832,
                    4.4103172725,
                    4.0135420457,
                    3.6155794819,
                    3.2165473115,
                    2.8165635811,
                    2.4157466191,
                    2.0142150003,
                    1.6120875107,
                    1.209483113,
                    0.8065209106,
                    0.4033201129,
                    0]
  end# >>>
  #return positive values of [elev1, elev2 ...] in radians for one day
  def self.daily_elevation(declination, latitude)# <<<
    #hour angle, 0 is midday at local solar time
    hra = [ 0, 15, 30, 45, 60, 75, 90, 105, 120, 135 ]
    daily_elev = Array.new
    pm_elev = Array.new
    hra.each do |angle|
      elevation = Math.asin(Math.sin(declination.degrees)*Math.sin(latitude.degrees) + Math.cos(declination.degrees)*Math.cos(latitude.degrees)*Math.cos(angle.degrees))
      if elevation >= 0
        pm_elev << elevation
      else
        break
      end
    end
    am_elev = pm_elev
    am_elev.drop(1).reverse!
    daily_elev = am_elev + pm_elev
  end# >>>
  #return { day1: [elev1, elev2...], day2: [elev1, elev2..]...}
  def annual_elevation(declination, latitude)# <<<
    annual_elev = Hash.new
    declination.each do |d|
        #annual_elev[d.count + 1] = 
    end
    
  end# >>>
end
