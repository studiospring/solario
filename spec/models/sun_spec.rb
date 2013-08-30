require 'spec_helper'

describe Sun do
  let(:sun) { Sun.new }
  subject { @sun }
  describe 'declination method' do
    it "should return angle in radians" do
      Sun.declination(1).should == 0.4011850422065163
    end
  end
  describe 'daily_elevation method' do
    it "should return array of elevations" do
       Sun.daily_elevation(1, 33).should == [0.012858311423347368, 0.21432380448642885, 0.4252137951043474, 0.6419099839801242, 0.8612064961386582, 1.078663171526293, 1.2815459750954357, 1.396022715843284, 1.2815459750954357, 1.078663171526293, 0.8612064961386582, 0.6419099839801242, 0.4252137951043474, 0.21432380448642885, 0.012858311423347368]
    end
  end
  describe 'annual_elevation method' do
    it "should include array of daily elevations within hash" do
      Sun.annual_elevation(33)[1].should == [0.012858311423347368, 0.21432380448642885, 0.4252137951043474, 0.6419099839801242, 0.8612064961386582, 1.078663171526293, 1.2815459750954357, 1.396022715843284, 1.2815459750954357, 1.078663171526293, 0.8612064961386582, 0.6419099839801242, 0.4252137951043474, 0.21432380448642885, 0.012858311423347368]
    end
  end
  describe 'vector instance method' do# <<<
    #azimuth and elev figures pulled from ~/Documents/Spring/solar/elevations.ods
    before { @sun.vector(0, 79.9693797693) }
    it "should return correct value for @sun.vector[:x]" do
      #when bearing is 150 deg
      @panel.vector[:x].should == -0.43301270189221946
    end
    it "should return correct value for @sun.vector[:y]" do
      #when bearing is 150 deg
      @panel.vector[:y].should == 0.25
    end
    it "should return correct value for @sun.vector[:z]" do
      #when tilt is 60 deg
      @panel.vector[:z].should == 0.8660254037844386
    end
  end# >>>
end

