require 'spec_helper'

describe PvOutput do

  describe 'search' do# <<<
    before { @systems_array = PvOutput.search('2031') }
    it 'returns array of systems from pvoutput.org' do
      @systems_array[0].should == {"name"=>" Solar 4 US", "size"=>"9360", "postcode"=>"4280", "orientation"=>"NW", "outputs"=>"81", "last_output"=>"2 days ago", "system_id"=>"249", "panel"=>"Solarfun", "inverter"=>"Aurora", "distance"=>"NaN", "latitude"=>"-27.831402", "longitude"=>"153.028469"}
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
