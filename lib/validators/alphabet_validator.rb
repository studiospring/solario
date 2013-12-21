class AlphabetValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    #need to convert date object to string, then test?
    unless value =~ /[a-zA-Z]*/
      record.errors[attribute] << (options[:message] || "contains a non-alphabetic character.")
    end
  end  

end

