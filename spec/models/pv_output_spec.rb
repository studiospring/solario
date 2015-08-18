require 'spec_helper'

describe PvOutput do
  before do @pvo = PvOutput.new(
    {'system_watts' => '2345',
     'postcode' => '1234',
     'orientation' => 'N',
     'tilt' => '23',
     'shade' => 'No',
     'total_output' => '54433',
     'efficiency' => '3.358',
     'entries' => '1000',
     'date_from' => '20101003',
     'date_to' => '20140114',
     'significance' => 0}
  ) end
  subject { @pvo }

  # stubs are defined in spec_helper.rb
  describe 'output_pa' do
    pending 'system id'
  end
  describe 'find_similar_sytem' do
    it "should return hash if similar system is found" do
      PvOutput.find_similar_system("4870 +NW").should ==
        {}
    end
    it "should return empty hash if system not found" do
      PvOutput.find_similar_system("1234 +S").should == {}
    end
  end
  describe 'search' do
    it 'returns array of systems from pvoutput.org' do
      PvOutput.search('4280 +NW')[0].should == {"name" => " Solar 4 US", "system_watts" => "9360", "postcode" => "4280", "orientation" => "NW", "entries" => "81", "last_entry" => "2 days ago", "id" => "249", "panel" => "Solarfun", "inverter" => "Aurora", "distance" => "NaN", "latitude" => "-27.831402", "longitude" => "153.028469"}
    end
    it "should update postcode" do
      pending
    end
  end
  describe 'get_system' do
    it 'should return system data from pvoutput.org' do
      PvOutput.get_system('100').should ==
        { 'id' => '100',
          'system_watts' => '2450',
          'panel_count' => '14',
          'panel_watts' => '175',
          'orientation' => 'N',
          'tilt' => 'NaN',
          'shade' => 'No',
          'install_date' => '20100101',
          'sec_panel_count' => '10',
          'sec_panel_watts' => '190',
          'sec_bearing' => 'W',
          'sec_tilt' => '30.5'
        }
    end
  end
  describe 'get_output' do
    it 'returns output of system from pvoutput.org' do
      pending 'query by id'
    end
  end
  describe 'get_statistic' do
    it 'returns hash of system data from pvoutput.org' do
      query_params = { :sid1 => '1000', :date_from => '20100901', :date_to => '20100927' }
      PvOutput.get_statistic(query_params).should ==
        {'total_output' => '246800',
         'efficiency' => '3.358',
         'date_from' => '20100901',
         'date_to' => '20100927'
        }
    end
  end

end
