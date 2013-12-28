require 'spec_helper'

describe Panel do
  #prevent tests from failing because of postcode_to_postcode_id callback
  PvQuery.skip_callback(:validation, :before, :postcode_to_postcode_id)
  let(:pv_query) { FactoryGirl.create(:pv_query) }
  let!(:irradiance) { FactoryGirl.create(:irradiance, postcode_id: pv_query.postcode_id) }
  before do
    @panel = pv_query.panels.build(tilt: 60, bearing: 150, panel_size: 31 )
  end
  subject { @panel }

  it { should respond_to(:tilt) }
  it { should respond_to(:bearing) }
  it { should respond_to(:panel_size) }
  it { should respond_to(:pv_query_id) }
  it { should respond_to(:pv_query) }
  its(:pv_query) { should eq pv_query }

  it { should be_valid }

  #validation# <<<
  describe 'when tilt is not present' do
    before { @panel.tilt = ' ' }
    it { should_not be_valid }
  end
  describe 'when tilt is too low' do
    before { @panel.tilt = -1 }
    it { should_not be_valid }
  end
  describe 'when tilt is too high' do
    before { @panel.tilt = 181 }
    it { should_not be_valid }
  end
  describe 'when tilt is not a number' do
    before { @panel.tilt = 'cd' }
    it { should_not be_valid }
  end
  describe 'when bearing is not present' do
    before { @panel.bearing = ' ' }
    it { should_not be_valid }
  end
  describe 'when bearing is too low' do
    before { @panel.bearing = -1 }
    it { should_not be_valid }
  end
  describe 'when bearing is too high' do
    before { @panel.bearing = 361 }
    it { should_not be_valid }
  end
  describe 'when bearing is not a number' do
    before { @panel.bearing = 'abc' }
    it { should_not be_valid }
  end
  describe 'when panel_size is not present' do
    before { @panel.panel_size = ' ' }
    it { should_not be_valid }
  end
  describe 'when panel_size is not a number' do
    before { @panel.panel_size = 'abc' }
    it { should_not be_valid }
  end
  #prevents form from being submitted
  #describe "when pv_query_id is not present" do
    #before { @panel.pv_query_id = nil }
    #it { should_not be_valid }
  #end# >>>
  describe 'vector instance method' do# <<<
    before { @panel.vector }
    it "should return correct value for @panel.vector[:x]" do
      #when bearing is 150 deg
      @panel.vector[:x].should be_within(0.001).of(-0.75000)
    end
    it "should return correct value for @panel.vector[:y]" do
      #when bearing is 150 deg
      @panel.vector[:y].should be_within(0.01).of(0.433012701)
    end
    it "should return correct value for @panel.vector[:z]" do
      #when tilt is 60 deg
      @panel.vector[:z].should be_within(0.001).of(0.5)
    end
  end# >>>
  describe 'dni_received_pa method' do# <<<
    #correct time_zone difference
    before { irradiance.direct = "0.50 1.66 2.74 3.74 4.66 5.50 6.26 6.94 7.54 8.06 8.50 8.86 9.14 9.34 9.46 9.50 9.46 9.34 9.14 8.86 8.50 8.06 7.54 6.94 6.26 5.50 4.66 3.74 2.74 1.66 0.50 1.00 2.16 3.24 4.24 5.16 6.00 6.76 7.44 8.04 8.56 9.00 9.36 9.64 9.84 9.96 10.00 9.96 9.84 9.64 9.36 9.00 8.56 8.04 7.44 6.76 6.00 5.16 4.24 3.24 2.16 1.00 0.50 1.66 2.74 3.74 4.66 5.50 6.26 6.94 7.54 8.06 8.50 8.86 9.14 9.34 9.46 9.50 9.46 9.34 9.14 8.86 8.50 8.06 7.54 6.94 6.26 5.50 4.66 3.74 2.74 1.66 0.50 0 1.16 2.24 3.24 4.16 5.00 5.76 6.44 7.04 7.56 8.00 8.36 8.64 8.84 8.96 9.00 8.96 8.84 8.64 8.36 8.00 7.56 7.04 6.44 5.76 5.00 4.16 3.24 2.24 1.16 0 0 0.44 1.43 2.35 3.19 3.96 4.65 5.27 5.81 6.28 6.67 6.98 7.22 7.39 7.48 7.50 7.44 7.30 7.09 6.81 6.45 6.01 5.50 4.92 4.25 3.52 2.71 1.82 0.86 0 0 0 0.10 0.93 1.70 2.42 3.08 3.68 4.22 4.70 5.13 5.50 5.81 6.06 6.26 6.40 6.48 6.50 6.46 6.37 6.22 6.01 5.74 5.42 5.04 4.60 4.10 3.54 2.93 2.26 1.53 0.74 0 0 0 0.70 1.42 2.08 2.68 3.22 3.70 4.13 4.50 4.81 5.06 5.26 5.40 5.48 5.50 5.46 5.37 5.22 5.01 4.74 4.42 4.04 3.60 3.10 2.54 1.93 1.26 0.53 0 0 0 0 0 0.42 1.08 1.68 2.22 2.70 3.13 3.50 3.81 4.06 4.26 4.40 4.48 4.50 4.46 4.37 4.22 4.01 3.74 3.42 3.04 2.60 2.10 1.54 0.93 0.26 0 0 0 0 0 0.70 1.42 2.08 2.68 3.22 3.70 4.13 4.50 4.81 5.06 5.26 5.40 5.48 5.50 5.46 5.37 5.22 5.01 4.74 4.42 4.04 3.60 3.10 2.54 1.93 1.26 0.53 0 0 0.10 0.93 1.70 2.42 3.08 3.68 4.22 4.70 5.13 5.50 5.81 6.06 6.26 6.40 6.48 6.50 6.46 6.37 6.22 6.01 5.74 5.42 5.04 4.60 4.10 3.54 2.93 2.26 1.53 0.74 0 0.44 1.43 2.35 3.19 3.96 4.65 5.27 5.81 6.28 6.67 6.98 7.22 7.39 7.48 7.50 7.44 7.30 7.09 6.81 6.45 6.01 5.50 4.92 4.25 3.52 2.71 1.82 0.86 0 0 0 1.16 2.24 3.24 4.16 5.00 5.76 6.44 7.04 7.56 8.00 8.36 8.64 8.84 8.96 9.00 8.96 8.84 8.64 8.36 8.00 7.56 7.04 6.44 5.76 5.00 4.16 3.24 2.24 1.16 0" }
    it "should return correct array" do
      @panel.dni_received_pa(irradiance.direct).last.should == 17.67
    end
    describe 'when no associated postcode is found' do
      before { @panel.pv_query.postcode = nil }
      it "should not raise an error" do
        lambda { @panel.dni_received_pa(irradiance.direct) }.should_not raise_error
      end
    end
  end# >>>
  describe 'dni_hash_received_pa method' do# <<<
    before do
      @dni_pa = "2.4 4.8 9.6 4.8 2.4 2.2 4.4 8.8 4.4 2.2 2.1 4.2 8.4 4.2 2.1 1.8 3.6 7.2 3.6 1.8 1.5 3.0 6.0 3.0 1.5 1.4 2.8 5.6 2.8 1.4 1.5 3.0 6.0 3.0 1.5 1.8 3.6 7.2 3.6 1.8 2.2 4.4 8.8 4.4 2.2 2.4 4.8 9.6 4.8 2.4 2.6 5.2 10.4 5.2 2.6 2.5 5.0 10.0 5.0 2.5"
    end
    it "should return a very big hash" do
      pending 'if this method is really necessary'
      #@panel.dni_received_pa(@dni_pa)[0][0].should == BigDecimal('0.4')
    end
  end# >>>
  describe 'avg_efficiency method' do# <<<
    it "should return correct value" do
      Panel.avg_efficiency(20, 0.98).should == 0.83 
    end
  end# >>>
  describe 'diffuse_received_pa method' do# <<<
    #before { @panel.annual_dni_received() }
    it "should return a very big array" do
      pending 'dummy data'
    end
  end# >>>
end
