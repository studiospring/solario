ActiveRecord::Base.class_eval do
  def self.custom_validate_range(*attr_names)
    options = attr_names.extract_options!
    validates_each(attr_names, options) do |record, attribute, value|
      record.errors[attribute] << value + " is outside acceptable range" unless options[:min] <= value and value <= options[:max]
    end
  end
end
