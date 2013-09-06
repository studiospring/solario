class Irradiance < ActiveRecord::Base
    
      validates :direct,       presence: true
      validates :diffuse,       presence: true
      validates :postcode_id,       presence: true
                          length: {},
                        numericality: {},
                        inclusion: {}

end
