class PvQuery < ActiveRecord::Base
  has_many :panels

  validates :postcode,  presence: true,
                        length: { maximum: 4 },
                        numericality: { only_integer: true }
end
