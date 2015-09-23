class Postcode < ActiveRecord::Base
  has_one :irradiance
  has_many :pv_queries

  validates :pcode,
            :presence => true,
            :length => { :maximum => 4 },
            :numericality => { :only_integer => true }
  validates :suburb,
            :presence => true
  validates :state,
            :presence => true,
            :inclusion => { :in => %w(ACT NSW NT QLD SA TAS VIC WA) }
  validates :latitude,
            :presence => true,
            :length => { :maximum => 11 }
  validates :latitude,
            :presence => true,
            :numericality => { :less_than => 50, :greater_than => -44 }
  validates :longitude,
            :presence => true,
            :length => { :maximum => 10 },
            :numericality => { :less_than => 160, :greater_than => 95 }
  validates :urban, :inclusion => { :in => [true, false] }

  URBAN_PV_SYSTEM_THRESHOLD = 5

  # Update urban attr only if it needs changing.
  # @arg [Array] PvOutput.search results.
  def update_urban(pvo_query_results)
    self.urban = !self.urban if update_urban?(pvo_query_results)
  end

  # @arg [Array] PvOutput.search results.
  def update_urban?(pvo_query_results)
    self.urban != urban?(pvo_query_results)
  end

  private

  # @arg [String] PvQuery.pvo_search_params
  def urban?(pvo_query_results)
    system_count_per_postcode(pvo_query_results) >= URBAN_PV_SYSTEM_THRESHOLD
  end

  # @arg [String] PvQuery.pvo_search_params
  # @return [Fixnum]
  def system_count_per_postcode(pvo_query_results)
    pvo_query_results.count { |system| system[:postcode] == self.pcode }
  end
end
