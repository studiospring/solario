require 'spec_helper'

describe Panel do
  let(:pv_query) { FactoryGirl.create(:pv_query) }
  before { @panel = pv_query.panels.build(tilt: 45, bearing: 100, panel_size: 31 ) }
  subject { @panel }

  it { should respond_to(:tilt) }
  it { should respond_to(:bearing) }
  it { should respond_to(:panel_size) }
  it { should respond_to(:pv_query_id) }
  it { should respond_to(:pv_query) }
  its(:pv_query) { should eq pv_query }

  it { should be_valid }

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
    before { @panel.panel_size = 'ABC' }
    it { should_not be_valid }
  end
  describe "when pv_query_id is not present" do
    before { @panel.pv_query_id = nil }
    it { should_not be_valid }
  end
end