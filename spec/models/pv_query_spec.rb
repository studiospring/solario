require 'spec_helper'

describe PvQuery do
  before { @pv_query = PvQuery.new(postcode: 1111) }
  subject { @pv_query }

  it { should respond_to(:postcode) }
  it { should respond_to(:panels) }

  it { should be_valid }

  describe 'when postcode is not present' do
    before { @pv_query.postcode = ' ' }
    it { should_not be_valid }
  end
  describe 'when postcode is the wrong length' do
    before { @pv_query.postcode = '12345' }
    it { should_not be_valid }
  end
  describe 'when postcode is not a number' do
    before { @pv_query.postcode = 'abcd' }
    it { should_not be_valid }
  end
  describe 'panel association' do
    before { @pv_query.save }

    it "should destroy associated panels" do
      panels = @pv_query.panels.to_a
      @pv_query.destroy
      expect(panels).not_to be_empty
      panels.each do |panel|
        expect(Panel.where(id: panel.id)).to be_empty
      end
    end
  end
  describe 'declination method' do
    it "should return angle in radians" do
      PvQuery.declination(1).should == 0.4011850422065163
    end
  end
  describe 'daily_elevation method' do
    it "should return array of elevations" do
       PvQuery.daily_elevation(1, 33).should == [ 0.01306583265353049, 0.21450544759451404, 0.4253756798235719, 0.6420591760579141, 0.8613530380161579, 1.0788262297399192, 1.2817755143185139, 1.3963767228427733, 1.2817755143185139, 1.0788262297399192, 0.8613530380161579, 0.6420591760579141, 0.4253756798235719, 0.21450544759451404, 0.01306583265353049] 
    end
  end
  describe 'annual_elevation method' do
    it "should include array of daily elevations within hash" do
      PvQuery.annual_elevation()
    end
  end
end
