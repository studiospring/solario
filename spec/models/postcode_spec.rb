require 'spec_helper'

describe Postcode do
  before { @postcode =  Postcode.new(postcode: 4321, suburb: 'Simsville', state: 'ABC', latitude: -12.123123, longitude: 123.456789) }
  subject { @postcode }

  it { should respond_to(:postcode) }
  it { should respond_to(:suburb) }
  it { should respond_to(:state) }
  it { should respond_to(:latitude) }
  it { should respond_to(:longitude) }

  it { should be_valid }

  describe 'when postcode is not present' do
    before { @postcode.postcode = ' ' }
    it { should_not be_valid }
  end
end
