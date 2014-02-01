require 'spec_helper'

describe PvOutput do
  let(:pvo) { FactoryGirl.create(:pv_output) }

  #stubs are defined in spec_helper.rb
  describe 'actual_output_pa' do
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
      PvOutput.search('2031')[0].should == {"name"=>" Solar 4 US", "size"=>"9360", "postcode"=>"4280", "orientation"=>"NW", "entries"=>"81", "last_entry"=>"2 days ago", "id"=>"249", "panel"=>"Solarfun", "inverter"=>"Aurora", "distance"=>"NaN", "latitude"=>"-27.831402", "longitude"=>"153.028469"}
    end
  end# >>>
  describe 'get_system' do# <<<
    #before { system_info = PvOutput.get_system(id) }
    it 'returns system data from pvoutput.org' do
      pending 'query by id'
    end
  end# >>>
  describe 'get_output' do# <<<
    #before { system_info = PvOutput.get_output(id) }
    it 'returns output of system from pvoutput.org' do
      pending 'query by id'
    end
  end# >>>
  describe 'get_statistic' do# <<<
    #before { statistics = PvOutput.get_statistic(id) }
    it 'returns hash of system data from pvoutput.org' do
      pending 'query by id'
    end
  end# >>>
  
end
