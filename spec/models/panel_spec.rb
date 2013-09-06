require 'spec_helper'

describe Panel do
  let(:pv_query) { FactoryGirl.create(:pv_query) }
  before { @panel = pv_query.panels.build(tilt: 60, bearing: 150, panel_size: 31 ) }
  subject { @panel }

  it { should respond_to(:tilt) }
  it { should respond_to(:bearing) }
  it { should respond_to(:panel_size) }
  it { should respond_to(:pv_query_id) }
  it { should respond_to(:pv_query) }
  its(:pv_query) { should eq pv_query }

  it { should be_valid }

  #validation
  describe 'when tilt is not present' do# <<<
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
      @panel.vector[:x].should == -0.43301270189221946
    end
    it "should return correct value for @panel.vector[:y]" do
      #when bearing is 150 deg
      @panel.vector[:y].should == 0.25
    end
    it "should return correct value for @panel.vector[:z]" do
      #when tilt is 60 deg
      @panel.vector[:z].should == 0.8660254037844386
    end
  end# >>>
  describe 'annual_dni_received method' do# <<<
    #before { @panel.annual_dni_received() }
    it "should return a very big hash" do
      pending 'dummy data'
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
