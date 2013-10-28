# == Schema Information
#
# Table name: irradiances
#
#  id          :integer          not null, primary key
#  direct      :text
#  diffuse     :text
#  postcode_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Irradiance < ActiveRecord::Base
  belongs_to :postcode
  #serialize :direct
  #serialize :diffuse
    
  validates :direct,       presence: true
  validates :diffuse,      presence: true
  validates :postcode_id,  presence: { message: 'id cannot be blank' },
    numericality: { only_integer: true ,
                    message: 'id is not a number' }

  #correct for difference between local timezone and timezone at which
  #insolation measurements were made (AEST)
  #return string of dni values
  def time_zone_corrected_dni# <<<
    irradiance = Irradiance.select('direct').where('postcode_id = ?', self.postcode_id).first
    self.correct_time_zone_diff(irradiance.direct)
  end# >>>
  #correct for difference between local timezone and timezone at which
  #insolation measurements were made (AEST)
  #return string of diffuse insolation values
  def time_zone_corrected_diffuse# <<<
    irradiance = Irradiance.select('diffuse').where('postcode_id = ?', self.postcode_id).first
    self.correct_time_zone_diff(irradiance.diffuse)
  end# >>>
  protected
    #remove insolation values from beginning or end of day (depending on time zone)
    #so that local time zone and times of insolation measurement match up
    def correct_time_zone_diff(insolation_string)# <<<
      insolation_array = insolation_string.split(' ')
      #refactor bc used in dni_pa_received?
      annual_increment = 12
      data_count = insolation_array.count #say, 180 
      data_per_day = data_count / annual_increment #180 / 12 = 15 
      synced_array = Array.new

      case self.postcode.state
        when 'WA' #remove first 4 values per month (assuming 1/2 hrly dni readings)
          annual_increment.times do
            insolation_array.slice!(0, 4)
            synced_array << insolation_array.shift(data_per_day - 4)
          end
        when 'SA', 'NT'
          annual_increment.times do
            insolation_array.slice!(1)
            synced_array << insolation_array.shift(data_per_day - 3)
            insolation_array.slice!(0, 3)
          end
        else #remove last 4 values per month
          annual_increment.times do
            synced_array << insolation_array.shift(data_per_day - 4)
            insolation_array.slice!(0, 4)
          end
      end 
      
      return synced_array.flatten.join(' ')
    end# >>>
end
