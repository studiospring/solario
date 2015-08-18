require 'spec_helper'

describe SolarTime do
  let(:sun) { Sun.new(:latitude, :longitude, :day) }
  # let(:sun) { FactoryGirl.create(:sun) }
  before { @sun = Sun.new(-20, 135, 'WA', 10, 14) }
  subject { @sun }

  describe 'to_lst' do
    before { @sun.to_lst }
    it "should convert local time to local solar time" do
      @sun.to_lst.should be_within(0.01).of(14.875)
    end
  end
  describe 'hra' do
    before { @sun.hra }
    it "should return the hour angle in degrees" do
      @sun.hra.should be_within(0.01).of(43.125)
    end
  end
end
