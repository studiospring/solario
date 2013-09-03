require 'spec_helper'

describe SolarTime do
  let(:sun) { Sun.new(:longitude, :day) }
  #let(:sun) { FactoryGirl.create(:sun) }
  before { @sun = Sun.new(135, 10) }
  subject { @sun }

  it "dummy instance has longitude attribute" do
    @sun.longitude.should == 135
  end

  describe 'class method' do
    describe 'b' do
      before { @sun.b(10) }
      it "should return 'b' degrees for a given day" do
        @sun.b(10).should be_within(0.002).of(-1.222)
      end
    end
    describe 'EoT' do
      before { sun.eot(10) }
      it "should return the Equation of Time for a given day" do
        @sun.eot(10).should be_within(0.002).of(-7.499)
      end
    end
    
  end
  describe 'instance method' do
    describe 'time correction factor' do
      before { @sun.time_correction(10) }
      it "should correct the time wrt day and position" do
        @sun.time_correction(10).should be_within(0.02).of(-67.499)
      end
    end
    describe 'to_lst' do# <<<
      before { @sun.to_lst(14, -67.499) }
      it "should convert local time to local solar time" do
        @sun.to_lst(14, -67.499).should be_within(0.01).of(12.88)
      end
    end# >>>
    describe 'hra' do
      before { @sun.hra(12.88) }
      it "should return the hour angle in radians" do
        @sun.hra(12.88).should be_within(0.01).of(0.23)
      end
    end
  end
end
