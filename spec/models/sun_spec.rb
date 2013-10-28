require 'spec_helper'

describe Sun do
  let(:sun) { Sun.new(:latitude, :longitude, :state, :day) }
  before { @sun = Sun.new(-20, 135, 'NSW', 10) }
  subject { @sun }

  describe 'elevation method' do
    it "should return elevation in radians" do
      @sun.elevation(15).should be_within(0.001).of(0.795018539487432)
    end
  end
  describe 'azimuth method' do
    it "should return correct azimuth in radians in the morning" do
      @sun.azimuth(-15).should be_within(0.001).of(0.6616369131917649)
    end
    it "should return correct azimuth in radians at solar noon" do
      @sun.azimuth(0).should eq(0)
    end
    it "should return correct azimuth in radians in the afternoon" do
      @sun.azimuth(30).should be_within(0.001).of(5.493424156038)
    end
  end
  describe 'declination method' do
    it "should return angle in radians" do
      @sun.declination.should be_within(0.001).of(0.38333384764823003) 
    end
  end
  describe 'lstm method' do
    it "should return local standard time meridian in degrees" do
      @sun.lstm.should eq(150)
    end
  end
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

