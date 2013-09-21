class Irradiance < ActiveRecord::Base
  belongs_to :postcode
  serialize :direct, JSON
  serialize :diffuse, JSON
    
  validates :direct,       presence: true
  validates :diffuse,      presence: true
  validates :postcode_id,  presence: { message: 'id cannot be blank' },
    numericality: { only_integer: true ,
                    message: 'id is not a number' }

end
