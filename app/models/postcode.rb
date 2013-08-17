class Postcode < ActiveRecord::Base
  validates :postcode,  presence: true,
                        length: { is: 4 },
                        numericality: { only_integer: true }
  validates :suburb,    presence: true
  validates :state,     presence: true,
                        inclusion: { in: %w(ACT NSW NT QLD SA TAS VIC WA) }
  validates :latitude,  presence: true,
                        length: { maximum: 10 },
                        inclusion: -14..10
                        #numericality: { less_than: 10 },
                        #numericality: { greater_than: -14 }
  validates :longitude, presence: true,
                        length: { maximum: 10 },
                        numericality: { less_than: 140 },
                        numericality: { greater_than: 100 }
end
