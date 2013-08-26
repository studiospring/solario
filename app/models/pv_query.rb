class PvQuery < ActiveRecord::Base
  has_many :panels, dependent: :destroy
  accepts_nested_attributes_for :panels

  validates :postcode,  presence: true,
                        length: { maximum: 4 },
                        numericality: { only_integer: true }
end
