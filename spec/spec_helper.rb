require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'webmock/rspec'
  require 'capybara/rails'
  require 'capybara/rspec'
  require 'capybara/poltergeist'

  #help speed up tests
  #comment out to log to log/test.log
  Rails.logger.level = 4

  Capybara.javascript_driver = :poltergeist
  Capybara.default_wait_time = 20
  WebMock.disable_net_connect!(allow_localhost: true)
  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  # Checks for pending migrations before tests are run.
  # If you are not using ActiveRecord, you can remove this line.
  ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

  RSpec.configure do |config|
    #replace requests to Pvoutput.org with stubs, using Webmock 
    config.before(:each) do
      stub_request(:get, "http://pvoutput.org/service/r2/search.jsp?country=Australia&key=#{Rails.application.secrets.pvo_api_key}&q=4280%20%2BNW&sid=#{Rails.application.secrets.pvo_system_id}").
        to_return(
          :status => 200,
          :body => " Solar 4 US,9360,4280,NW,81,2 days ago,249,Solarfun,Aurora,NaN,-27.831402,153.028469
                 Solar Chaos,1480,4870,NW,14,5 weeks ago,694,ET Solar ET-M572185,PCM Solar King 1500,NaN,-16.883938,145.746732
                 Solar Frontier 2.97KW 2768,2952,2768,W,72,Yesterday,387,Solar Frontier,Xantrex 2.8 AU,NaN,-33.737863,150.922732
                 solar powered muso,3600,5074,NW,146,5 days ago,151,Sunpower,Fronius,NaN,-34.878302,138.663553")

      #for find_similar_system spec
      #stub_request(:get, "http://pvoutput.org/service/r2/search.jsp?country=Australia&key=#{Rails.application.secrets.pvo_api_key}&q=1234%20%2BS&sid=#{Rails.application.secrets.pvo_system_id}").
        #to_return(
          #:status => 200, 
          #:body => " Solar 4 US,9360,4280,NW,81,2 days ago,249,Solarfun,Aurora,NaN,-27.831402,153.028469
                 #Solar Chaos,1480,4870,NW,14,5 weeks ago,694,ET Solar ET-M572185,PCM Solar King 1500,NaN,-16.883938,145.746732
                 #Solar Frontier 2.97KW 2768,2952,2768,W,72,Yesterday,387,Solar Frontier,Xantrex 2.8 AU,NaN,-33.737863,150.922732
                 #solar powered muso,3600,5074,NW,146,5 days ago,151,Sunpower,Fronius,NaN,-34.878302,138.663553")
      stub_request(:get, "http://pvoutput.org/service/r2/search.jsp?country=Australia&key=d4688e594b218f1746dec6cff0e34c2216dc675e&q=1234%20%2BS&sid=26011").
         to_return(:status => 200, :body => "", :headers => {})
      stub_request(:get, "http://pvoutput.org/service/r2/search.jsp?country=Australia&key=d4688e594b218f1746dec6cff0e34c2216dc675e&q=4870%20%2BNW&sid=26011").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
         to_return(:status => 200, :body => "", :headers => {})

      #for find_similar_system spec
      #stub_request(:get, "http://pvoutput.org/service/r2/getsystem.jsp?key=#{Rails.application.secrets.pvo_api_key}sid=#{Rails.application.secrets.pvo_system_id}&sid1=151").
         #to_return(
           #:status => 200,
           #:body => " Solar 4 US,9360,4280,NW,81,2 days ago,249,Solarfun,Aurora,NaN,-27.831402,153.028469
                 #Solar Chaos,1480,4870,NW,14,5 weeks ago,694,ET Solar ET-M572185,PCM Solar King 1500,NaN,-16.883938,145.746732
                 #Solar Frontier 2.97KW 2768,2952,2768,W,72,Yesterday,387,Solar Frontier,Xantrex 2.8 AU,NaN,-33.737863,150.922732
                 #solar powered muso,3600,5074,NW,146,5 days ago,151,Sunpower,Fronius,NaN,-34.878302,138.663553")

       stub_request(:get, "http://pvoutput.org/service/r2/getsystem.jsp?key=d4688e594b218f1746dec6cff0e34c2216dc675e&sid=26011&sid1=151").
         to_return(
           :status => 200, 
           :body => "" )

      stub_request(:get, "http://pvoutput.org/service/r2/getsystem.jsp?key=#{Rails.application.secrets.pvo_api_key}&sid=#{Rails.application.secrets.pvo_system_id}&sid1=100").
        to_return(
          :status => 200, 
          :body => "PVOutput Demo,2450,2199,14,175,Enertech,1,2000,CMS,N,NaN,No,20100101,-33.907725,151.026108,5;60.0,10,190,W,30.5,40.0;1,12,93;1")

      stub_request(:get, "http://pvoutput.org/service/r2/getstatistic.jsp?date_from=20100901&date_to=20100927&key=#{Rails.application.secrets.pvo_api_key}&sid=#{Rails.application.secrets.pvo_system_id}&sid1=1000").
         to_return(
           :status => 200, 
           :body => "246800,246800,8226,2000,11400,3.358,27,20100901,20100927,4.653,20100916")

    end

    # ## Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = true

    #enable Devise test helpers like 'sign_in'
    config.include Devise::TestHelpers, :type => :controller

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    # Run specs in random order to surface order dependencies. If you find an
    # order dependency and want to debug it, you can fix the order by providing
    # the seed, which is printed after each run.
    #     --seed 1234
    config.order = "random"
    config.include Capybara::DSL
  end
  Capybara.register_driver :poltergeist do |app|
    options = { debug: false,
                js_errors: true, #false can cause phantomjs to crash
                time_out: 50 }
    Capybara::Poltergeist::Driver.new(app, options)
  end
end
Spork.each_run do
  # This code will be run each time you run your specs.

end

