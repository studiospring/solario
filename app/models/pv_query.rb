class PvQuery < ActiveRecord::Base

  has_many :panels, dependent: :destroy
  belongs_to :postcode
  accepts_nested_attributes_for :panels#, reject_if: lambda { |a| a[:tilt].blank? }

  validates :postcode_id,  presence: true,
    numericality: { only_integer: true }

  before_save do
    postcode = Postcode.where('pcode = ?', self.postcode_id).first
    self.postcode_id = postcode.id
  end
end
