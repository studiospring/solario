class PvQuery < ActiveRecord::Base
  has_many :panels

  validate :postcode, presence: true
end
