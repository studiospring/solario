# To use:
# require 'core_ext/string'
class String
  # convert '0 1 3 5 ...' to { 1: [0, 1, 3, 5], 2: [...] }
  # annual increment is number of times solar readings are averaged per year
  # daily increment is number of times solar readings are averaged per day
  def data_string_to_hash(annual_increment)
    # convert string to array
    data_array = self.split
    daily_increment = data_array.count / annual_increment
    if daily_increment.is_a? Integer
      data_hash = {}
      annual_increment.times do |count|
        one_day = Array.new
        daily_increment.times do
          one_day << data_array.shift.to_f
        end
        data_hash[count] = one_day
      end
      return data_hash
    else
      # log error
      logger.debug 'Number of dni values does not match annual_increment.'
    end
  end
end
