class PvQuery < ActiveRecord::Base

  has_many :panels, dependent: :destroy
  accepts_nested_attributes_for :panels#, reject_if: lambda { |a| a[:tilt].blank? }

  validates :postcode,  presence: true,
                        length: { maximum: 4 },
                        numericality: { only_integer: true }

  #return hash of hourly energy input received by panel for whole year (KWh/sqm)
  #{ day1: [KWh1, KWh2...]... }
  #0 KWh values must be included so that time can be calculated from position in
  #array
  def annual_dni_received(annual_dni)# <<<
    received_input = Hash.new
    365.times do |day|
      received_input[day] = Array.new
      #assume 5am is the Eastern Standard Time of first value
      dni_time = 5
      annual_dni[day].each do |dni|
        if dni == 0
          #pad with 0 values so that time can be deduced
          received_input[day] << 0
        else
          #TODO: create this method!
          lst = Sun.to_lst(dni_time)
          #returns sun_position[:azimuth], sun_position[:elevation]
          sun_position = Sun.position_at(day, lst, latitude)
          sun_vector = Sun.vector(sun_position[:azimuth], sun_position[:elevation])
          received_input[day] << self.relative_angle(sun_vector) * dni
        end
        dni_time = dni_time + 1
      end
    end
    return received_input
  end# >>>
end
