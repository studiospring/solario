require 'spec_helper'

describe PvOutput do
  #let(:postcode) { FactoryGirl.create(:postcode) }

  #stubs are defined in spec_helper.rb
  describe 'search' do# <<<
    it 'returns array of systems from pvoutput.org' do
      #does not work
      #postcode = double('Postcode')
      #postcode.stub(:update_urban?).and_return(true)
      #expect(PvOutput.search('2031')[0]).to eq '2'
      PvOutput.search('2031')[0].should == {"name"=>" Solar 4 US", "size"=>"9360", "postcode"=>"4280", "orientation"=>"NW", "outputs"=>"81", "last_output"=>"2 days ago", "system_id"=>"249", "panel"=>"Solarfun", "inverter"=>"Aurora", "distance"=>"NaN", "latitude"=>"-27.831402", "longitude"=>"153.028469"}
    end
  end# >>>
  describe 'get_system' do# <<<
    #before { system_info = PvOutput.get_system(system_id) }
    it 'returns system data from pvoutput.org' do
      pending 'query by system_id'
    end
  end# >>>
  describe 'get_output' do# <<<
    #before { system_info = PvOutput.get_output(system_id) }
    it 'returns output of system from pvoutput.org' do
      pending 'query by system_id'
    end
  end# >>>
  describe 'get_statistic' do# <<<
    #before { statistics = PvOutput.get_statistic(system_id) }
    it 'returns hash of system data from pvoutput.org' do
      pending 'query by system_id'
    end
  end# >>>
  
end
