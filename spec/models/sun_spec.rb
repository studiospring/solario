require 'spec_helper'

describe Sun do
  let(:sun) { Sun.new(:latitude, :longitude, :state, :day, :local_time) }
  before { @sun = Sun.new(-20, 135, 'NSW', 10, 8) }
  subject { @sun }

  describe 'elevation method' do
    it "should return elevation in radians" do
      @sun.elevation.should be_within(0.001).of(0.0700345)
    end
  end
  describe 'azimuth method' do
    it "should return correct azimuth in radians in the morning" do
      @sun.azimuth.should be_within(0.001).of(1.133309310)
    end
    describe 'at solar noon' do
      before { @sun.local_time = 16 }
      it "should return correct azimuth in radians" do
        pending
        #@sun.azimuth.should eq(0)
      end
    end
    describe 'in the afternoon' do
      before { @sun.local_time = 16 }
      it "should return correct azimuth in radians" do
        @sun.azimuth.should be_within(0.001).of(5.3814629359)
      end
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
      @sun.vector[:x].should be_within(0.001).of(0.422625918)
    end
    it "should return correct value for @sun.vector[:y]" do
      @sun.vector[:y].should be_within(0.001).of(0.903598645841)
    end
    it "should return correct value for @sun.vector[:z]" do
      @sun.vector[:z].should be_within(0.001).of(0.0699772)
    end
  end# >>>
end

