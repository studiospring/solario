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
    postcode = Postcode.where('pcode = ?', self.postcode_id).select('id').first
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
end
