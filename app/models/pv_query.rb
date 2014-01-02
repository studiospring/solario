# == Schema Information
#
# Table name: pv_queries
#
#  id          :integer          not null, primary key
#  created_at  :datetime
#  updated_at  :datetime
#  postcode_id :integer
#

class PvQuery < ActiveRecord::Base

  has_many :panels, dependent: :destroy
  belongs_to :postcode
  accepts_nested_attributes_for :panels#, reject_if: lambda { |a| a[:tilt].blank? }

  validates :postcode_id,  presence: true,
    numericality: { only_integer: true }

  after_validation :postcode_to_postcode_id

  #change postcode param to postcode_id
  def postcode_to_postcode_id# <<<
    #prevent other postcodes from being queried bc no data available
    postcode = Postcode.where('pcode = ?', 1234).select('id').first
    #postcode = Postcode.where('pcode = ?', self.postcode_id).select('id').first
    #if there is no postcode, calling postcode.id will cause error
    unless postcode.nil?
      self.postcode_id = postcode.id
    end
  end# >>>
  #return array of combined output for all panels in pv array
  #array must be converted to string to be used by graph (join(' '))
  def avg_output_pa# <<<
    postcode_id = self.postcode.try('id')
    if postcode_id.nil?
      #handle error
      return []
    end
    begin #in case values have not been input for this postcode
      dni_pa = self.postcode.irradiance.time_zone_corrected_dni
      #diffuse_pa = self.postcode.irradiance.time_zone_corrected_diffuse
    rescue
      return []
    else
      panels_array = Array.new
      self.panels.each do |panel|
        panels_array << panel.dni_received_pa(dni_pa)
        #TODO: method not created yet
        #panels_array << panel.diffuse_received_pa(diffuse_pa)
      end
      efficiency = Panel.avg_efficiency(20, 0.99)
      #add direct and diffuse inputs of all panels, factor in efficiency
      return panels_array.transpose.map { |x| ((x.reduce(:+)) * efficiency).round(2) }
    end
  end# >>>
  #return volume under graph (kW)
  def total_annual_output# <<<

  end# >>>
  #protected
    #convert avg_output_pa array to nested array of graph's column heights
    #returns [[a, b, f, g], [b, c, g, h]...]
    def column_heights# <<<
      annual_increment = Irradiance.annual_increment
      daily_increment = Irradiance.daily_increment
      graph_array = self.avg_output_pa
      #[[jan1, jan2...], [feb1, feb2...]...]
      data_by_month = Array.new
      annual_increment.times { data_by_month << graph_array.shift(daily_increment) }
      #duplicate and append jan data so that dec-jan volume can be easily calculated
      data_by_month << data_by_month[0]

      columns = Array.new #[[a, b, f, g], [b, c, g, h]...]
      annual_increment.times do |month|
        (daily_increment - 1).times do |time|
          column_data = [data_by_month[month][time].to_f,
                         data_by_month[month][time + 1].to_f,
                         data_by_month[month + 1][time].to_f, 
                         data_by_month[month + 1][time + 1].to_f]
          #remove 0 height columns
          if column_data.any? { |datum| datum > 0 }
            columns << column_data
          end
        end
      end
      return columns
    end# >>>
    #return volume of 1 column of graph
    def column_volume# <<<
      
    end# >>>
end
