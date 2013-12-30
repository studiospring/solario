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
    #this method traverses graph data's grid "the wrong way" (columns and rows are reversed),
    #but this way is marginally cleaner. Therefore, do not rely on this to provide monthly totals.
    #returns [[a, b, f, g], [b, c, g, h]...]
    def column_heights# <<<
      annual_increment = Irradiance.annual_increment
      graph_data = self.avg_output_pa
      columns = Array.new #[[a, b, f, g], [b, c, g, h]...]
      graph_data.each_with_index do |height, i| 
        column_data = Array.new #[a, b, f, g]
        if i + 1 % annual_increment == 0 #prevent column being created with last and first values in month
          break
        else
          if i + annual_increment + 1 == graph_data.length #reach last column
            return columns
          else
            column_data << graph_data[i].to_f << graph_data[i + 1].to_f << graph_data[i + annual_increment].to_f << graph_data[i + annual_increment + 1].to_f
          end
        end
        unless column_data.inject(:+) == 0 #ignore columns with zero height
          columns << column_data
        end
      end
    end# >>>
    #return volume of 1 column of graph
    def column_volume# <<<
      
    end# >>>
end
