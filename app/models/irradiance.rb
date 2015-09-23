class Irradiance < ActiveRecord::Base
  belongs_to :postcode
  # serialize :direct
  # serialize :diffuse

  validates :direct,       :presence => true
  validates :diffuse,      :presence => true
  validates :postcode_id,  :presence => { :message => 'id cannot be blank' },
                           :numericality => { :only_integer => true,
                                              :message => 'id is not a number' }
  # Annual increment of insolation data.
  ANNUAL_INCREMENT = 12

  # Daily increment of insolation data.
  # Irradiance data spans 17 hours, but 2 hours are chopped off to account for
  #   timezone differences. Graph shows irradiance from 5am to 8pm, local standard time.
  # Currently set at 30min intervals. Therefore (15 * 2) + 1 (fencepost) = 31.
  DAILY_INCREMENT = 31

  # Correct for difference between local timezone and timezone at which
  #   insolation measurements were made (AEST).
  # @return [String] dni values.
  def time_zone_corrected_dni
    irradiance = Irradiance.select('direct').where('postcode_id = ?', self.postcode_id).first
    self.correct_time_zone_diff(irradiance.direct)
  end

  # Correct for difference between local timezone and timezone at which
  #   insolation measurements were made (AEST).
  # @return [String] diffuse insolation values.
  def time_zone_corrected_diffuse
    irradiance = Irradiance.select('diffuse').where('postcode_id = ?', self.postcode_id).first
    self.correct_time_zone_diff(irradiance.diffuse)
  end

  protected

  # Remove insolation values from beginning or end of day (depending on time zone)
  #   so that local time zone and times of insolation measurement match up.
  # @return [String]
  def correct_time_zone_diff(insolation_string)
    insolation_array = insolation_string.split(' ')
    data_count = insolation_array.count # say, 180
    data_per_day = data_count / ANNUAL_INCREMENT # 180 / 12 = 15
    synced_array = []

    case self.postcode.state
    when 'WA' # remove first 4 values per month (assuming 1/2 hrly dni readings)
      ANNUAL_INCREMENT.times do
        insolation_array.slice!(0, 4)
        synced_array << insolation_array.shift(data_per_day - 4)
      end
    when 'SA', 'NT'
      ANNUAL_INCREMENT.times do
        insolation_array.slice!(1)
        synced_array << insolation_array.shift(data_per_day - 3)
        insolation_array.slice!(0, 3)
      end
    # Remove last 4 values per month.
    else
      ANNUAL_INCREMENT.times do
        synced_array << insolation_array.shift(data_per_day - 4)
        insolation_array.slice!(0, 4)
      end
    end

    synced_array.flatten.join(' ')
  end
end
