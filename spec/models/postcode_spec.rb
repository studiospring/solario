require 'spec_helper'

describe Postcode do
  before { @postcode =  Postcode.new(postcode: 4321, suburb: 'Simsville', state: 'WA', latitude: -12.123123, longitude: 123.456789) }
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
  describe 'when postcode is the wrong length' do
    before { @postcode.postcode = '12345' }
    it { should_not be_valid }
  end
  describe 'when postcode is not a number' do
    before { @postcode.postcode = 'abcd' }
    it { should_not be_valid }
  end
  
  describe 'when suburb is not present' do
    before { @postcode.suburb = ' ' }
    it { should_not be_valid }
  end

  describe 'when state is not present' do
    before { @postcode.state = ' ' }
    it { should_not be_valid }
  end
  describe 'when state is not on list' do
    before { @postcode.state = 'ABC' }
    it { should_not be_valid }
  end

  describe 'when latitude is not present' do
    before { @postcode.latitude = ' ' }
    it { should_not be_valid }
  end
  describe 'when latitude is outside range' do
    before { @postcode.latitude = '12' }
    it { should_not be_valid }
  end
  describe 'when latitude is too long' do
    before { @postcode.latitude = '-12.1111111' }
    it { should_not be_valid }
  end

  describe 'when longitude is not present' do
    before { @postcode.longitude = ' ' }
    it { should_not be_valid }
  end
  describe 'when longitude is outside range' do
    before { @postcode.longitude = '12' }
    it { should_not be_valid }
  end
  describe 'when longitude is too long' do
    before { @postcode.longitude = '-12.1111111' }
    it { should_not be_valid }
  end
end
