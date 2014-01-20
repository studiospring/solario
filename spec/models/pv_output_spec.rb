require 'spec_helper'

describe PvOutput do

  describe 'search' do# <<<
    before { @systems_array = PvOutput.search('2031') }
    it 'returns array of systems from pvoutput.org' do
      expect(@systems_array).to be_an_instance_of(String)
      #systems_array[:body].should == 'hello'
    end
  end# >>>
  describe 'get_system' do# <<<
    #before { system_info = PvOutput.get_system }
    #it 'returns system data from pvoutput.org' do
      #uri = URI('http://pvoutput.org/service/r2/')

      #response = Net::HTTP.get(uri)

      #expect(response).to be_an_instance_of(String)
    #end
    #before { @pv_query.postcode_id = nil }
    #it { should_not be_valid }
  end# >>>
end
