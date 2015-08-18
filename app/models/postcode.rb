# == Schema Information
#
# Table name: postcodes
#
#  id        :integer          not null, primary key
#  pcode     :integer
#  suburb    :string(255)
#  state     :string(255)
#  latitude  :decimal(, )
#  longitude :decimal(, )
#  urban     :boolean          default(FALSE)
#

class Postcode < ActiveRecord::Base
  has_one :irradiance
  has_many :pv_queries

  validates :pcode,
    presence: true,
    length: { maximum: 4 },
    numericality: { only_integer: true }
  validates :suburb,
    presence: true
  validates :state,
    presence: true,
    inclusion: { in: %w(ACT NSW NT QLD SA TAS VIC WA) }
  validates :latitude,
    presence: true,
    length: { maximum: 11 }
  validates :latitude,
    presence: true,
    numericality: { less_than: 50, greater_than: -44 }
  validates :longitude,
    presence: true,
    length: { maximum: 10 },
    numericality: { less_than: 160, greater_than: 95 }
  validates :urban, inclusion: { in: [true, false] }

  URBAN_PV_SYSTEM_THRESHOLD = 5

  def update_urban
    self.urban = !self.urban
  end

  def update_urban?(pvo_query_results)
    self.urban != define_as_urban?(pvo_query_results)
  end

  private

    def define_as_urban?(pvo_query_results)
      system_count_per_postcode(pvo_query_results) >= URBAN_PV_SYSTEM_THRESHOLD
    end

    def system_count_per_postcode(pvo_query_results)
      pvo_query_results.count { |system| system[:postcode] == self.pcode }
    end
end
