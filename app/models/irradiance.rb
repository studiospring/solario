class Irradiance < ActiveRecord::Base
  belongs_to :postcode
  # serialize :direct
  # serialize :diffuse

  validates :direct,       :presence => true
  validates :diffuse,      :presence => true
  validates :postcode_id,  :presence => { :message => 'id cannot be blank' },
                           :numericality => {
                             :only_integer => true,
                             :message => 'id is not a number',
                           }

  # Number of data points in each direct and diffuse string.
  DATAPOINT_COUNT = 420

  # Irradiance is averaged per month.
  GRADATIONS_PA = 12

  DATAPOINTS_PER_DAY = DATAPOINT_COUNT / GRADATIONS_PA

  # Irradiance is averaged every 30 mins.
  DAILY_INTERVAL = 30

  # Irradiance data spans 17 hours, but 2 hours are chopped off to account for
  #   timezone differences. Graph shows irradiance from 5am to 8pm, local standard time.
  USABLE_DATAPOINTS_PER_DAY = DATAPOINTS_PER_DAY - (2 * 60) / DAILY_INTERVAL

  # Remove irradiance values from beginning or end of day (depending on time zone)
  #   so that local time zone and times of irradiance measurement match up.
  # @arg [String] 'direct' or 'diffuse'.
  # @return [Array<Float>]
  def tz_corrected_irradiance(type)
    irradiance_array = local_irradiance(:type => type).split.map(&:to_f)

    # Irradiance split into values for each month.
    irradiance_by_month = irradiance_array.each_slice(DATAPOINTS_PER_DAY)
    irradiance_by_month.flat_map { |month| month.slice!(tz_slice_index, USABLE_DATAPOINTS_PER_DAY) }
  end

  # @arg [String] 'direct' or 'diffuse'
  # @return [String] annual direct normal insolation values.
  def local_irradiance(type: 'direct')
    irradiance = Irradiance.select(type).where('postcode_id = ?', postcode_id).first
    irradiance.send(type)
  rescue ActiveModel::MissingAttributeError
    ''
  end

  protected

  # @return [Fixnum] index to begin slice of irradiance array, depending on timezone.
  def tz_slice_index
    case self.postcode.state
    when 'WA' then (2 * 60) / DAILY_INTERVAL
    when 'SA', 'NT' then 30 / DAILY_INTERVAL
    else
      0
    end
  end
end
