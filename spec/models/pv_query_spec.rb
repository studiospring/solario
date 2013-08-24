require 'spec_helper'

describe PvQuery do
  before { @pv_query = PvQuery.new(postcode: 1111) }
  subject { @pv_query }

  it { should respond_to(:postcode) }
  it { should respond_to(:panels) }

  it { should be_valid }

  describe 'when postcode is not present' do
    before { @pv_query.postcode = ' ' }
    it { should_not be_valid }
  end
  describe 'when postcode is the wrong length' do
    before { @pv_query.postcode = '12345' }
    it { should_not be_valid }
  end
  describe 'when postcode is not a number' do
    before { @pv_query.postcode = 'abcd' }
    it { should_not be_valid }
  end
end
