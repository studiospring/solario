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

  validates :pcode,     presence: true,
    length: { maximum: 4 },
    numericality: { only_integer: true }
  validates :suburb,    presence: true
  validates :state,     presence: true,
    inclusion: { in: %w(ACT NSW NT QLD SA TAS VIC WA) }
  validates :latitude,  presence: true,
    length: { maximum: 11 }
  validates :latitude,  presence: true,
    numericality: { less_than: 50, 
      greater_than: -44 }
  validates :longitude, presence: true,
    length: { maximum: 10 },
    numericality: { less_than: 160,
      greater_than: 95 }
  validates :urban, inclusion: { in: [true, false] }

  #update urban attr if postcode has enough pv systems to be considered 'urban'
  def update_urban?(pvo_query_results)# <<<
    system_count = 0
    #find out how many systems from queried postcode (not including surrounds) are returned
    pvo_query_results.each do |system|
      if system[:postcode] == self.pcode
        system_count += 1
      end
    end
    if self.urban == false && system_count > 4
      self.urban = true
      return true
    elsif self.urban == true && system_count < 5 
      self.urban = false
      return true
    else
      return false
    end
  end# >>>
end
