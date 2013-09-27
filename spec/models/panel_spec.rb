require 'spec_helper'

describe Panel do
  #prevent tests from failing because of postcode_to_postcode_id callback
  PvQuery.skip_callback(:validation, :before, :postcode_to_postcode_id)
  let(:pv_query) { FactoryGirl.create(:pv_query) }
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
      @panel.vector[:x].should be_within(0.001).of(-0.43301270189221946)
    end
    it "should return correct value for @panel.vector[:y]" do
      #when bearing is 150 deg
      @panel.vector[:y].should be_within(0.01).of(0.25)
    end
    it "should return correct value for @panel.vector[:z]" do
      #when tilt is 60 deg
      @panel.vector[:z].should be_within(0.001).of(0.8660254037844386)
    end
  end# >>>
  describe 'annual_dni_received method' do# <<<
    before do
      @annual_dni = "2.4 4.8 9.6 4.8 2.4 2.2 4.4 8.8 4.4 2.2 2.1 4.2 8.4 4.2 2.1 1.8 3.6 7.2 3.6 1.8 1.5 3.0 6.0 3.0 1.5 1.4 2.8 5.6 2.8 1.4 1.5 3.0 6.0 3.0 1.5 1.8 3.6 7.2 3.6 1.8 2.2 4.4 8.8 4.4 2.2 2.4 4.8 9.6 4.8 2.4 2.6 5.2 10.4 5.2 2.6 2.5 5.0 10.0 5.0 2.5"
    end
    it "should return a very big hash" do
      @panel.annual_dni_received(@annual_dni)[0][0].should == 0.4
    end
  end# >>>
  describe 'annual_diffuse_received method' do# <<<
    #before { @panel.annual_dni_received() }
    it "should return a very big hash" do
      pending 'dummy data'
    end
  end# >>>
  describe 'avg_annual_ouput method' do# <<<
    it "should return the energy output of the panel" do
      pending 'annual_dni_received method'
    end
  end# >>>
end
