require 'spec_helper'

describe Sun do
  let(:sun) { Sun.new(:latitude, :longitude, :day) }
  before { @sun = Sun.new(-20, 135, 10) }
  subject { @sun }

  describe 'elevation method' do
    it "should return elevation in radians" do
      @sun.elevation(15).should be_within(0.001).of(0.795018539487432)
    end
  end
  describe 'azimuth method' do
    it "should return azimuth in radians" do
      @sun.azimuth(15).should be_within(0.001).of(0.6616369131917649)
    end
  end
  describe 'declination method' do
    it "should return angle in radians" do
      @sun.declination.should be_within(0.001).of(0.38333384764823003) 
    end
  end
  #method no longer used
  #describe 'daily_elevation method' do
    #it "should return array of elevations" do
       #Sun.daily_elevation(1, 33).should == [0.012858311423347368, 0.21432380448642885, 0.4252137951043474, 0.6419099839801242, 0.8612064961386582, 1.078663171526293, 1.2815459750954357, 1.396022715843284, 1.2815459750954357, 1.078663171526293, 0.8612064961386582, 0.6419099839801242, 0.4252137951043474, 0.21432380448642885, 0.012858311423347368]
    #end
  #end
  #method no longer used
  #describe 'annual_elevation method' do
    #it "should include array of daily elevations within hash" do
      #Sun.annual_elevation(33)[1].should == [0.012858311423347368, 0.21432380448642885, 0.4252137951043474, 0.6419099839801242, 0.8612064961386582, 1.078663171526293, 1.2815459750954357, 1.396022715843284, 1.2815459750954357, 1.078663171526293, 0.8612064961386582, 0.6419099839801242, 0.4252137951043474, 0.21432380448642885, 0.012858311423347368]
    #end
  #end
  describe 'vector instance method' do# <<<
    it "should return correct value for @sun.vector[:x]" do
      @sun.vector(9)[:x].should be_within(0.001).of(0.48662785778917966)
    end
    it "should return correct value for @sun.vector[:y]" do
      @sun.vector(9)[:y].should be_within(0.001).of(0.8265353226938301)
    end
    it "should return correct value for @sun.vector[:z]" do
      @sun.vector(9)[:z].should be_within(0.001).of(0.28290049198069644)
    end
  end# >>>
end

