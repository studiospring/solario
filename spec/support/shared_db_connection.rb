#help speed up tests
#requires ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
#in spec_helper.rb
#http://stackoverflow.com/questions/16365810/capybara-assertions-fail-under-poltergeist
class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil
 
  def self.connection
    @@shared_connection || retrieve_connection
  end
end
