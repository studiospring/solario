class PvQuery < ActiveRecord::Base
  require "core_ext/numeric"

  has_many :panels, :dependent => :destroy
  belongs_to :postcode
  accepts_nested_attributes_for :panels # , reject_if: lambda { |a| a[:tilt].blank? }

  delegate :irradiance, :to => :postcode

  validates :postcode_id,  :presence => true,
                           :numericality => { :only_integer => true }

  after_validation :postcode_to_postcode_id

  # @return [Float] pv_query output_pa (Wh) derived from pvo empirical data.
  def empirical_output_pa(pvo_output_per_system_watts)
    (self.system_watts * pvo_output_per_system_watts).round
  end

  # @return [Float] possible system wattage (W).
  def system_watts
    panels.reduce(0) { |a, e| a + e.possible_watts }
  end

  # @return string with which to search pvo e.g. "1234 25km +S 80 tilt".
  def pvo_search_params
    # Too many params causes nil query result even when system exists.
    # {self.pvo_search_distance} #{self.northmost_facing_panel.tilt} tilt
    "#{self.postcode.pcode} +#{self.pvo_orientation}"
  end

  # Change postcode param to postcode_id.
  def postcode_to_postcode_id
    # prevent other postcodes from being queried bc no data available
    # postcode = Postcode.where('pcode = ?', 1234).select('id').first
    postcode = Postcode.where('pcode = ?', self.postcode_id).select('id').first
    # if there is no postcode, calling postcode.id will cause error
    unless postcode.nil?
      self.postcode_id = postcode.id
    end
  end

  # @return [Array<Float>] of combined output for all panels in pv array.
  # Array must be converted to string to be used by graph (join(' ')).
  # move to Panel, rename => add_all_panels_outputs?
  def output_pa_array
    # efficiency = Panel.avg_efficiency(20, 0.15)
    # add direct and diffuse inputs of all panels, factor in efficiency
    add_all_panels_outputs # .map { |x| (x * efficiency).to_f.round(2) }
  end

  # @return [Array<Float>] annual irradiances sums direct and diffuse of all panel.
  def add_all_panels_outputs
    panels.reduce([]) do |a, panel|
      a << panel.dni_received_pa(irradiance.tz_corrected_irradiance('direct'))

      # TODO: method not created yet
      # a <<panel.dni_received_pa(irradiance.tz_corrected_irradiance('diffuse'))
    end.transpose.reduce(:+)
    # If postcode.irradiance is nil.
  rescue
    raise Module::DelegationError
  end

  # Formula is approximation. Cannot confirm accuracy of result yet.
  # Untested because factory is not set up correctly.
  # http://math.stackexchange.com/questions/438766/volume-of-irregular-solid
  # @return [Float] volume under graph (Wh).
  def output_pa
    total_volume = 0
    const = volume_constant
    self.column_heights.each do |column|
      # vol = 0.25 * length_of_insolation_reading *
      #   readings_per_annual_increment * column.inject(:+)
      total_volume += (const * column.inject(:+))
    end
    # convert to Wh
    (total_volume * 3600).round
  end

  # TODO: check this formula!
  # @return [Fixnum] length of side of graph column (kinda).
  def volume_constant
    daily_int_in_hrs = Irradiance::DAILY_INTERVAL / 60.0
    daily_int_in_hrs * Irradiance::DAYS_IN_ANNUAL_GRADATION * 24 / 4
  end

  # private
  # Convert output_pa_array to nested array of graph's column heights.
  # @return [Array<Array<Float>>] [[a, b, f, g], [b, c, g, h]...]
  def column_heights
    # [[jan1, jan2...], [feb1, feb2...]...]
    data_by_month = []

    Irradiance::GRADATIONS_PA.times do
      data_by_month << output_pa_array.shift(Irradiance::USABLE_DATAPOINTS_PER_DAY)
    end

    # Duplicate and append jan data so that dec-jan volume can be easily calculated.
    data_by_month << data_by_month[0]

    # [[a, b, f, g], [b, c, g, h]...]
    columns = []

    Irradiance::GRADATIONS_PA.times do |month|
      (Irradiance::USABLE_DATAPOINTS_PER_DAY - 1).times do |time|
        column_data = [data_by_month[month][time].to_f,
                       data_by_month[month][time + 1].to_f,
                       data_by_month[month + 1][time].to_f,
                       data_by_month[month + 1][time + 1].to_f]
        # remove 0 height columns
        if column_data.any? { |datum| datum > 0 }
          columns << column_data
        end
      end
    end

    columns
  end

  # @return [String] bearing that faces closest to north in pvo readable format.
  def pvo_orientation
    o = Hash[
      337.5..360, 'N',
      0..22.5, 'N',
      22.5..67.5, 'NE',
      292.5..337.5, 'NW',
      67.5..112.5, 'E',
      247.5..292.5, 'W',
      112.5..157.5, 'SE',
      202.5..247.5, 'SW',
      157.5..202.5, 'S'
    ]

    o.find { |k, _| k.include?(northmost_facing_panel.bearing) }.last
  end

  # @return [Panel] panel that faces closest to north in one pvquery system.
  def northmost_facing_panel
    panels.reduce do |current, the_next|
      current.bearing.deg_to_north <= the_next.bearing.deg_to_north ? current : the_next
    end
  end

  # @return [String] optimal distance to search pvo.
  def pvo_search_distance
    if self.postcode.urban
      '5km'
    else
      '25km'
    end
  end
end
