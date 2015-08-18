class DateValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    # need to convert date object to string, then test?
    unless value.acts_like_date?
      record.errors[attribute] << (options[:message] || "is not a date")
    end
  end

end
