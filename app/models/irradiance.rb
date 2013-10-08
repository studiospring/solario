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

end
