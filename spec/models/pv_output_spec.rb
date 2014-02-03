require 'spec_helper'

describe PvOutput do
  let(:pvo) { FactoryGirl.create(:pv_output) }

  #stubs are defined in spec_helper.rb
  describe 'output_pa' do
    pending 'system id'
  end
  describe 'find_similar_sytem' do# <<<
    it "should return hash if similar system is found" do
      pending 'query by id'
    end
    it "should return empty hash if system not found" do
      pending 'query by id'
    end
  end# >>>
  describe 'search' do# <<<
    it 'returns array of systems from pvoutput.org' do
      #does not work
      #postcode = double('Postcode')
      #postcode.stub(:update_urban?).and_return(true)
      #expect(PvOutput.search('2031')[0]).to eq '2'
      PvOutput.search('4280 +NW')[0].should == {"name"=>" Solar 4 US", "system_watts"=>"9360", "postcode"=>"4280", "orientation"=>"NW", "entries"=>"81", "last_entry"=>"2 days ago", "id"=>"249", "panel"=>"Solarfun", "inverter"=>"Aurora", "distance"=>"NaN", "latitude"=>"-27.831402", "longitude"=>"153.028469"}
    end
    it "should update postcode" do
      pending
    end
  end# >>>
  describe 'get_system' do# <<<
    it 'should return system data from pvoutput.org' do
      PvOutput.get_system('100').should == "PVOutput Demo,2450,2199,14,175,Enertech,1,2000,CMS,N,NaN,No,20100101,-33.907725,151.026108,5;60.0,20.5,8.0,15.0,NaN,40.0;1,12,93;1"
    end
  end# >>>
  describe 'get_output' do# <<<
    it 'returns output of system from pvoutput.org' do
      pending 'query by id'
    end
  end# >>>
  describe 'get_statistic' do# <<<
    it 'returns hash of system data from pvoutput.org' do
      query_params = { sid1: '1000', date_from: '20100901', date_to: '20100930' }
      PvOutput.get_statistic(query_params).should == '246800,246800,8226,2000,11400,3.358,27,20100901,20100927,4.653,20100916'
    end
  end# >>>
  
end
