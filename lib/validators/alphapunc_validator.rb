class AlphapuncValidator < Neo4j::Rails::Model

  def validate_each(record, attribute, value)
    # need to convert date object to string, then test?
    unless value =~ /[a-zA-Z\-\s_(),.;:]/
      record.errors[attribute] << (options[:message] || "can only contain letters or certain punctuation characters.")
    end
  end

end
