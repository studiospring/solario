require 'spec_helper'

describe SolarTime do
  let(:sun) { Sun.new(:latitude, :longitude, :day) }
  #let(:sun) { FactoryGirl.create(:sun) }
  before { @sun = Sun.new(-20, 135, 10) }
  subject { @sun }

    describe 'to_lst' do# <<<
      before { @sun.to_lst(14) }
      it "should convert local time to local solar time" do
        @sun.to_lst(14).should be_within(0.01).of(12.88)
      end
    end# >>>
    describe 'hra' do
      before { @sun.hra(12.88) }
      it "should return the hour angle in degrees" do
        @sun.hra(12.88).should be_within(0.01).of(13.2)
      end
    end
end
