#To use:
#require 'core_ext/string'
class String
  #convert '0 1 3 5 ...' to { 1: [0, 1, 3, 5], 2: [...] }
  #annual increment is number of times solar readings are averaged per year
  #daily increment is number of times solar readings are averaged per day
  def data_string_to_hash(annual_increment, daily_increment)
    #TODO: error handling, if numbers do not match
    #convert string to array
    data_array = self.split
    data_hash = Hash.new
    annual_increment.times do |count|
      one_day = Array.new
      daily_increment.times do 
        one_day << data_array.shift.to_f
      end
      data_hash[count] = one_day
    end
    return data_hash
  end
end
