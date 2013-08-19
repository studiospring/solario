class Postcode < ActiveRecord::Base
  validates :pcode,     presence: true,
                        length: { is: 4 },
                        numericality: { only_integer: true }
  validates :suburb,    presence: true
  validates :state,     presence: true,
                        inclusion: { in: %w(ACT NSW NT QLD SA TAS VIC WA) }
  validates :latitude,  presence: true,
                        length: { maximum: 11 }
  #problem with negative value?
  #custom_validate_range :latitude, { min: -14, max: 14 }
                        #numericality: { less_than: 10 },
                        #numericality: { greater_than: -14 }
  validates :longitude, presence: true,
                        length: { maximum: 10 },
                        numericality: { less_than: 140 },
                        numericality: { greater_than: 100 }
end
