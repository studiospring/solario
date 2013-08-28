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
       PvQuery.daily_elevation(1, 33).should == [0.012858311423347368, 0.21432380448642885, 0.4252137951043474, 0.6419099839801242, 0.8612064961386582, 1.078663171526293, 1.2815459750954357, 1.396022715843284, 1.2815459750954357, 1.078663171526293, 0.8612064961386582, 0.6419099839801242, 0.4252137951043474, 0.21432380448642885, 0.012858311423347368]
    end
  end
  describe 'annual_elevation method' do
    it "should include array of daily elevations within hash" do
      PvQuery.annual_elevation(33)[1].should == [0.012858311423347368, 0.21432380448642885, 0.4252137951043474, 0.6419099839801242, 0.8612064961386582, 1.078663171526293, 1.2815459750954357, 1.396022715843284, 1.2815459750954357, 1.078663171526293, 0.8612064961386582, 0.6419099839801242, 0.4252137951043474, 0.21432380448642885, 0.012858311423347368]
    end
  end
end
