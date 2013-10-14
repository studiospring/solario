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
  #return graph data (string) of combined output for all panels in pv array
  def avg_output_pa# <<<
    irradiance_query = Irradiance.select('direct, diffuse').where('postcode_id = ?', @pv_query.postcode.id).first
    if irradiance_query.nil?
      dni_pa = nil
      diffuse_pa = nil
    else
      dni_pa = irradiance_query.direct
      diffuse_pa = irradiance_query.diffuse
    end
    #irradiance.nil? ? @dni_pa = nil : @dni_pa = irradiance.direct
    #convert to array
    #dni_array = dni_pa.split(" ").map { |s| s.to_i }
    #diffuse_array = diffuse_pa.split(" ").map { |s| s.to_i }
    #add arrays
    #irradiance = [dni_array, diffuse_array]
    #total = irradiance.transpose.map {|x| x.reduce(:+)}
    
    panels_array = Array.new
    self.panels.each do |panel|
      panels_array << panel.dni_received_pa(dni_pa) #return array?
    end

    
  end# >>>
end
