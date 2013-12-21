class RangeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value, { min:, max)
    unless min < value < max
      record.errors[attribute] << (options[:message] || "is not within the valid range")
    end
  end
end
