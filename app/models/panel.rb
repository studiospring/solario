# == Schema Information
#
# Table name: panels
#
#  id          :integer          not null, primary key
#  tilt        :integer
#  bearing     :integer
#  panel_size  :decimal(, )
#  pv_query_id :integer
#

class Panel < ActiveRecord::Base
  require 'core_ext/numeric'
  require 'core_ext/string'

  belongs_to :pv_query

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
  GRAPH_START_TIME = 5
  # Increment graph by this amount (30 min)
  DAILY_INCREMENT = 0.5

  # @return [Float]
  def possible_watts
    self.panel_size * POWER_DENSITY
  end

  # Convert tilt and bearing to vector notation.
  # @return [Hash<Hash, Float>]: vector[:x], [:y], [:z].
  def vector
    vector = {}
    hypotenuse = Math.cos((90 - self.tilt).to_rad).abs
    vector[:x] = hypotenuse * Math.cos(self.bearing.to_rad)
    vector[:y] = hypotenuse * Math.sin(self.bearing.to_rad)
    vector[:z] = Math.sin((90 - self.tilt).to_rad)
    vector
  end

  # no longer necessary?
  # @param [Num]
  # @return [Float] input (Watts/sqm) for one hr from direct normal irradiance (dni).
  def hourly_direct_input(hourly_dni)
    hourly_dni * Math.cos(self.relative_angle())
  end

  # @return [Float] output of solar panel (kWh).
  def hourly_output
    self.hourly_direct_input(dni)
  end

  # @return [Array<Num>] hourly Direct Normal Insolation received by panel over the
  #   course of 1 year (in kW) [0, 2.4, 3.0, ...].
  # 0 kW values must be included so that time can be calculated from position in array.
  # Use this instead of dni_hash_received_pa because graph uses string format.
  def dni_received_pa(time_zone_corrected_dni_pa)
    annual_increment = Irradiance.annual_increment
    days_in_increment = (365 / annual_increment).round
    # In case there is no postcode.
    begin
      latitude = self.pv_query.postcode.latitude
      longitude = self.pv_query.postcode.longitude
      state = self.pv_query.postcode.state
    rescue
      return []
    else
      # Set graph start time here (and below) and in pv_queries.js.coffee.
      sun = Sun.new(latitude, longitude, state, 1, 5)
      dni_pa_array = time_zone_corrected_dni_pa.split(' ')
      dni_count = dni_pa_array.count # say, 420
      dnis_per_day = dni_count / annual_increment # 420 / 12 = 31
      dni_received_pa = []

      dni_pa_array.each_with_index do |datum, i|
        dni = datum.to_f
        relative_angle = self.relative_angle(sun.vector)

        # dni_received_pa << sun.hra
        dni_received_pa << (self.panel_insolation(dni, relative_angle) * self.panel_size).round(2)

        sun.local_time = sun.local_time + DAILY_INCREMENT
        # Change sun values only after 1 day has looped.
        if (i - dnis_per_day + 1) % dnis_per_day == 0
          sun.local_time = GRAPH_START_TIME
          # Increment sun's day so that sun vector is correct.
          sun.day = sun.day + days_in_increment
        end
      end

      return dni_received_pa
    end
  end

  # @return [Hash] hourly Direct Normal Insolation received by panel over the course of 1 year (in kW).
  # { day1: [kW1, kW2...]... }
  # 0 kW values must be included so that time can be calculated from position in hash.
  # dni_pa is irradiances.direct ( string )
  # Currently broken.
  def dni_hash_received_pa(dni_pa)
    annual_increment = Irradiance.annual_increment
    days_in_increment = (365 / annual_increment).round
    dni_received_pa_hash = dni_pa.data_string_to_hash(annual_increment)
    latitude = self.pv_query.postcode.latitude
    longitude = self.pv_query.postcode.longitude
    sun = Sun.new(latitude, longitude, 1, 6)
    # use this for dummy data (only, at present)
    dni_received_pa_hash.each do |key, diurnal_dni|
      # assume 6am is the Universal Time of first value
      local_time = 6
      panel_insolation = Array.new
      diurnal_dni.map do |dni|
        relative_angle = self.relative_angle(sun.vector)
        panel_insolation << (self.panel_insolation(dni, relative_angle) * self.panel_size).round(2)
        # set daily increment here
        local_time += 3
      end
      dni_received_pa_hash[key] = panel_insolation
      # increment sun's day so that sun vector is correct
      sun.day = sun.day + days_in_increment
    end
    dni_received_pa_hash
  end

  # @return [Array<Num>] hourly diffuse insolation received by panel over the course of 1 year (in kW).
  # [kWh1, kWh2...]
  # 0 KWh values must be included so that time can be calculated from position in array.
  def diffuse_received_pa
    # TODO: refactor, add test
    # No diffuse data in database, so cannot debug.
    irradiance = Irradiance.select('diffuse').where('postcode_id = ?', self.pv_query.postcode_id).first
    irradiance.nil? ? diffuse = nil : diffuse = irradiance.diffuse
    diffuse_array = diffuse.split(" ").map { |s| s.to_i }
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

  # dummy method
  # currently no data to confirm solar panels behave this way!
  # efficiency must have 0 in front! eg 0.99
  def self.avg_efficiency(lifespan, overall_efficiency)
    total_efficiency = 0

    lifespan.times do |year|
      total_efficiency += overall_efficiency**year
    end

    (total_efficiency / lifespan).round(2)
  end

  # @param [Hash<Hash, Float>]
  # @return [Float] angle of incident light relative to panel in radians
  #   (where 0 is directly perpendicular to panel surface).
  def relative_angle(sun_vector)
    panel_vector = self.vector
    foo = (panel_vector[:x] * sun_vector[:x] + panel_vector[:y] * sun_vector[:y] + panel_vector[:z] * sun_vector[:z])
    bar = Math.sqrt(panel_vector[:x]**2 + panel_vector[:y]**2 + panel_vector[:z]**2)
    baz = Math.sqrt(sun_vector[:x]**2 + sun_vector[:y]**2 + sun_vector[:z]**2)
    Math.acos(foo / bar * baz).round(2)
  end

  # @param [Hash<Hash, Float>]
  # TODO: apparently above method is not accurate, try different formula
  # http://www.juergenwiki.de/work/wiki/doku.php?id=public:angle_between_two_vectors
  def relative_angle2(sun_vector)
    panel_vector = self.vector

    # dot_product(a,b) == length(a) * length(b) * cos(angle)
    (panel_vector[:x] * sun_vector[:x] + panel_vector[:y] * sun_vector[:y] + panel_vector[:z] * sun_vector[:z])
    # length(cross_product(a,b)) == length(a) * length(b) * sin(angle)

    # For a robust angle between 3-D vectors, your actual computation should be:

    # s = length(cross_product(a,b))
    # c = dot_product(a,b)
    # angle = atan2(s, c)

  end

  # @return [Float] insolation received by 1sqm module via vector method.
  # S_module = S_incident * cos(relative_angle)
  def panel_insolation(incident_light, relative_angle)
    # calculate only if relative angle <= 90 degrees, else return 0
    if relative_angle <= 1.57
      (incident_light * Math.cos(relative_angle)).round(2)
    else
      0
    end
  end
end
