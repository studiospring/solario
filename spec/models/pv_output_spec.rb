require 'rails_helper'

describe PvOutput do
  before(:all) do
    @pvo = PvOutput.new(
      { 'system_watts' => '2345',
        'postcode' => '1234',
        'orientation' => 'N',
        'tilt' => '23',
        'shade' => 'No',
        'total_output' => '54433',
        'efficiency' => '3.358',
        'entries' => '1000',
        'date_from' => '20101003',
        'date_to' => '20140114',
        'significance' => 0 }
    )

    stub_request(:get, "http://pvoutput.org/service/r2/getstatistic.jsp?date_from=20100901&date_to=20100927&key=#{Rails.application.secrets.pvo_api_key}&sid=#{Rails.application.secrets.pvo_system_id}&sid1=1000")
      .to_return(
        :status => 200,
        :body => "246800,246800,8226,2000,11400,3.358,27,20100901,20100927,4.653,20100916")

    stub_request(:get, "http://pvoutput.org/service/r2/search.jsp?country=Australia&key=#{Rails.application.secrets.pvo_api_key}&q=4870%20%2BNW&sid=#{Rails.application.secrets.pvo_system_id}")
      .to_return(
        :status => 200,
        :body => "")

    stub_request(:get, "http://pvoutput.org/service/r2/search.jsp?country=Australia&key=#{Rails.application.secrets.pvo_api_key}&q=1234%20%2BS&sid=#{Rails.application.secrets.pvo_system_id}")
      .to_return(
        :status => 200,
        :body => "")
  end

  let(:postcode) { FactoryGirl.create(:postcode) }

  subject { @pvo }

  describe 'output_pa' do
    skip 'system id'
  end

  describe 'find_similar_sytem' do
    it "should return hash if similar system is found" do
      expect(PvOutput.find_similar_system("4870 +NW")).to eq({})
    end

    it "should return empty hash if system not found" do
      expect(PvOutput.find_similar_system("1234 +S")).to eq({})
    end
  end

  describe 'search' do
    it 'returns array of systems from pvoutput.org' do
      pvo_systems = { "name" => " Solar 4 US",
                      "system_watts" => "9360",
                      "postcode" => "4280",
                      "orientation" => "NW",
                      "entries" => "81",
                      "last_entry" => "2 days ago",
                      "id" => "249",
                      "panel" => "Solarfun",
                      "inverter" => "Aurora",
                      "distance" => "NaN",
                      "latitude" => "-27.831402",
                      "longitude" => "153.028469" }

      expect(PvOutput.search('4280 +NW')[0]).to eq(pvo_systems)
    end

    it "should update postcode" do
      skip
    end
  end

  describe 'get_system' do
    before do
      stub_request(:get, "http://pvoutput.org/service/r2/getsystem.jsp?key=#{Rails.application.secrets.pvo_api_key}&sid=#{Rails.application.secrets.pvo_system_id}&sid1=100")
        .to_return(
          :status => 200,
          :body => "PVOutput Demo,2450,2199,14,175,Enertech,1,2000,CMS,N,NaN,No,20100101,-33.907725,151.026108,5;60.0,10,190,W,30.5,40.0;1,12,93;1")
    end

    it 'should return system data from pvoutput.org' do
      system_data = { 'id' => '100',
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

      expect(PvOutput.get_system('100')).to eq(system_data)
    end
  end

  describe 'get_output' do
    it 'returns output of system from pvoutput.org' do
      skip 'query by id'
    end
  end

  describe 'get_statistic' do
    before do
      stub_request(:get, "http://pvoutput.org/service/r2/getstatistic.jsp?date_from=20100901&date_to=20100927&key=#{Rails.application.secrets.pvo_api_key}&sid=#{Rails.application.secrets.pvo_system_id}&sid1=1000")
        .to_return(
          :status => 200,
          :body => "246800,246800,8226,2000,11400,3.358,27,20100901,20100927,4.653,20100916")
    end

    it 'returns hash of system data from pvoutput.org' do
      query_params = { :sid1 => '1000',
                       :date_from => '20100901',
                       :date_to => '20100927' }

      system_stats = { 'total_output' => '246800',
                       'efficiency' => '3.358',
                       'date_from' => '20100901',
                       'date_to' => '20100927' }

      expect(PvOutput.get_statistic(query_params)).to eq(system_stats)
    end
  end
end
