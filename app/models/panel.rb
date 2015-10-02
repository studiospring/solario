class Panel < ActiveRecord::Base
  require 'core_ext/numeric'
  require 'core_ext/string'

  belongs_to :pv_query

  delegate :postcode, :to => :pv_query

  validates :tilt,
            :presence => true,
            :length => { :maximum => 2 },
            :numericality => { :greater_than_or_equal_to => 0,
                               :less_than_or_equal_to => 90 }
  validates :bearing,
            :presence => true,
            :length => { :maximum => 3 },
            :numericality => { :greater_than_or_equal_to => 0,
                               :less_than_or_equal_to => 360 }
  validates :panel_size,
            :presence => true,
            # TODO: not producing error on 0. Numericality does not work either.
            :inclusion => {:in => 1..500,
                           :message => 'is not a valid number'}

  # Polycrystalline silicon, 13.1% module efficiency.
  # Watts per_square_metre.
  POWER_DENSITY = 130
  # 5:00am
  GRAPH_START_TIME = 5

  # @return [Float]
  def possible_watts
    self.panel_size * POWER_DENSITY
  end

  # @arg [Array<Float>] irradiance values.
  # @return [Array<Float>] hourly Direct Normal Insolation received by panel over the
  #   course of 1 year (in kW) [0, 2.4, 3.0, ...].
  # 0 kW values must be included so that time can be calculated from position in array.
  def dni_received_pa(tz_corrected_irradiance)
    days_per_increment = Irradiance::DAYS_IN_ANNUAL_GRADATION
    sun = Sun.new(postcode.latitude, postcode.longitude, postcode.state, 1, 5)
    res = []

    tz_corrected_irradiance.each do |day|
      sun.local_time = GRAPH_START_TIME

      day.each do |datum|
        res << dni_received(sun, datum)
        sun.local_time += Irradiance::DAILY_INTERVAL / 60.0
      end

      sun.day += days_per_increment
    end

    res
  end

  # @return [Array<Num>] hourly diffuse insolation received by panel over
  #   the course of 1 year (in kWh).
  # 0 KWh values must be included so that time can be calculated from position in array.
  def diffuse_received_pa
    # TODO: refactor, add test
    # No diffuse data in database, so cannot debug.
    irradiance = Irradiance.local_irradiance(:type => 'diffuse')
    irradiance.nil? ? diffuse = nil : diffuse = irradiance.diffuse
    diffuse_array = diffuse.split(" ").map(&:to_i)
    diffuse_array.map! { |value| (value * self.panel_size).to_i }
    diffuse_array
  end

  # Currently not in use
  # Add annual insolation hash to return total energy received.
  def self.annual_received_total(annual_received_hash)
    annual_total = 0

    annual_received_hash.each do |_day, hourly_dni|
      daily_total = hourly_dni.inject(:+)
      annual_total += daily_total
    end

    annual_total
  end

  # http://www.greenrhinoenergy.com/solar/technologies/pv_energy_yield.php
  # pre = preconversion efficiency, sys = system efficiency, rel = relative
  # module efficiency, nom = nominal module efficiency
  # nominal (and sometimes relative) module efficiency is available from panel spec sheets
  # TODO: refactor to panel_brand model if efficiencies vary greatly with brand
  def self.overall_efficiency(pre: 0.96, sys: 0.98, rel: 0.95, nom: 0.16)
    (pre * sys * rel * nom).round(2)
  end

  # currently no data to confirm solar panels behave this way!
  # efficiency must have 0 in front! eg 0.99
  def self.avg_efficiency(lifespan: 25, overall_efficiency: 0.97)
    total_efficiency = lifespan.times.reduce(0) do |total_eff, year|
      total_eff + overall_efficiency**year
    end

    (total_efficiency / lifespan).round(2)
  end

  # @arg [Hash<Hash, Float>]
  # TODO: apparently above method is not accurate, try different formula
  # http://www.juergenwiki.de/work/wiki/doku.php?id=public:angle_between_two_vectors
  def relative_angle2(sun_vector)
    panel_vector = vector

    # dot_product(a,b) == length(a) * length(b) * cos(angle)
    panel_vector[:x] * sun_vector[:x] +
      panel_vector[:y] * sun_vector[:y] +
      panel_vector[:z] * sun_vector[:z]
    # length(cross_product(a,b)) == length(a) * length(b) * sin(angle)

    # For a robust angle between 3-D vectors, your actual computation should be:

    # s = length(cross_product(a,b))
    # c = dot_product(a,b)
    # angle = atan2(s, c)
  end

  private

  # arg [Sun], [Float].
  # @return [Float].
  def dni_received(sun, dni)
    (panel_insolation(dni, relative_angle(sun.vector)) * panel_size).round(2).to_f
  end

  # @return [Float] insolation received by 1sqm module via vector method.
  # S_module = S_incident * cos(relative_angle)
  def panel_insolation(incident_light, relative_angle)
    # calculate only if relative angle <= 90 degrees, else return 0
    if relative_angle <= 1.57
      (incident_light * Math.cos(relative_angle)).round(2).to_f
    else
      0
    end
  end

  # @arg [Hash<Hash, Float>]
  # @return [Float] angle of incident light relative to panel in radians
  #   (where 0 is directly perpendicular to panel surface).
  def relative_angle(sun_vector)
    denominator = relative_angle_denominator(vector) * relative_angle_denominator(sun_vector)
    Math.acos(relative_angle_numerator(sun_vector) / denominator).round(2)
  end

  # @arg [Hash]
  # @return [Fixnum]
  def relative_angle_numerator(sun_vector)
    combined_vectors = vector.values.zip(sun_vector.values)
    combined_vectors.reduce(0) { |a, e| a + e.reduce(:*) }
  end

  # @arg [Hash]
  # @return [Fixnum]
  def relative_angle_denominator(vector)
    Math.sqrt(vector.reduce(0) { |sum, (_, v)| sum + v**2 })
  end

  # Convert tilt and bearing to vector notation.
  # @return [Hash<Hash, Float>]: vector[:x], [:y], [:z].
  def vector
    hyp = hypotenuse
    {
      :x => hyp * Math.cos(bearing.to_rad),
      :y => hyp * Math.sin(bearing.to_rad),
      :z => Math.sin((90 - tilt).to_rad),
    }
  end

  # @return [Bignum].
  def hypotenuse
    Math.cos((90 - tilt).to_rad).abs
  end
end
