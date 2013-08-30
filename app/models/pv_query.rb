class PvQuery < ActiveRecord::Base
  require 'core_ext/numeric'

  has_many :panels, dependent: :destroy
  accepts_nested_attributes_for :panels#, reject_if: lambda { |a| a[:tilt].blank? }

  validates :postcode,  presence: true,
                        length: { maximum: 4 },
                        numericality: { only_integer: true }

end
