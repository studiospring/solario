require 'rails_helper'

describe PvOutput do
  let(:base_uri) { "http://pvoutput.org/service/r2/" }
  let(:api_key) { 'my_api_key' }
  let(:system_id) { 'my_system_id' }

  let(:search_body) do
    "Solar 4 US,9360,4280,NW,81,2 days ago,249,Solarfun,Aurora,NaN,-27.831402,153.028469
    Solar Chaos,1480,4870,NW,14,5 weeks ago,694,ET Solar ET-M572185,PCM Solar King 1500,NaN,-16.883938,145.746732
    Solar Frontier 2.97KW 2768,2952,2768,W,72,Yesterday,387,Solar Frontier,Xantrex 2.8 AU,NaN,-33.737863,150.922732
    solar powered muso,3600,5074,NW,146,5 days ago,151,Sunpower,Fronius,NaN,-34.878302,138.663553"
  end

  let(:postcode) { FactoryGirl.create(:postcode) }

  describe 'output_pa' do
    skip 'system id'
  end

  describe 'find_similar_system' do
    context 'when similar system is found' do
      before :each do
        stub_request(:get, "#{base_uri}search.jsp?country=Australia&key=#{api_key}&q=4870%20%2BNW&sid=#{system_id}")
          .to_return(:status => 200, :body => search_body)
      end

      it "should return hash if similar system is found" do
        expect(PvOutput.find_similar_system("4870 +NW")).to eq({})
      end
    end

    context 'when similar system is not found' do
      before :each do
        stub_request(:get, "#{base_uri}search.jsp?country=Australia&key=#{api_key}&q=1234%20%2BS&sid=#{system_id}")
          .to_return(:status => 200, :body => "")
      end

      it "should return empty hash if system not found" do
        expect(PvOutput.find_similar_system("1234 +S")).to eq({})
      end
    end
  end

  describe 'search' do
    let(:pvo_systems) do
      { "name" => "Solar 4 US",
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
        "longitude" => "153.028469"
      }
    end

    before do
      stub_request(:get, "#{base_uri}search.jsp?country=Australia&key=#{api_key}&q=4280%20%2BNW&sid=#{system_id}")
         .to_return(:status => 200, :body => search_body)
    end

    it 'returns array of systems from pvoutput.org' do
      expect(PvOutput.search('4280 +NW')[0]).to eq(pvo_systems)
    end

    it "should update postcode" do
      skip
    end
  end

  describe 'get_system' do
    let(:system_data) do
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

    before do
      stub_request(:get, "#{base_uri}getsystem.jsp?key=#{api_key}&sid=#{system_id}&sid1=100")
        .to_return(
          :status => 200,
          :body => "PVOutput Demo,2450,2199,14,175,Enertech,1,2000,CMS,N,NaN,No,20100101,-33.907725,151.026108,5;60.0,10,190,W,30.5,40.0;1,12,93;1")
    end

    it 'should return system data from pvoutput.org' do
      expect(PvOutput.get_system('100')).to eq(system_data)
    end
  end

  describe 'get_output' do
    it 'returns output of system from pvoutput.org' do
      skip 'query by id'
    end
  end

  describe 'get_statistic' do
    let(:query_params) do
      { :sid1 => '1000',
        :date_from => '20100901',
        :date_to => '20100927'
      }
    end

    let(:system_stats) do
      { 'total_output' => '246800',
        'efficiency' => '3.358',
        'date_from' => '20100901',
        'date_to' => '20100927'
      }
    end

    before do
      stub_request(:get, "#{base_uri}getstatistic.jsp?date_from=20100901&date_to=20100927&key=#{api_key}&sid=#{system_id}&sid1=1000")
        .to_return(
          :status => 200,
          :body => "246800,246800,8226,2000,11400,3.358,27,20100901,20100927,4.653,20100916")
    end

    it 'returns hash of system data from pvoutput.org' do
      expect(PvOutput.get_statistic(query_params)).to eq(system_stats)
    end
  end
end
