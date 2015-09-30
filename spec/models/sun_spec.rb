require 'rails_helper'

describe Sun do
  let(:sun) { Sun.new(-20, 135, 'NSW', 10, 8) }

  describe 'elevation method' do
    it "should return elevation in radians" do
      expect(sun.elevation).to be_within(0.001).of(0.0700345)
    end
  end

  describe 'azimuth method' do
    it "should return correct azimuth in radians in the morning" do
      expect(sun.azimuth).to be_within(0.001).of(1.133309310)
    end

    describe 'in the afternoon' do
      before { sun.local_time = 16 }

      it "should return correct azimuth in radians" do
        expect(sun.azimuth).to be_within(0.001).of(5.3814629359)
      end
    end
  end

  describe 'declination method' do
    it "should return angle in radians" do
      expect(sun.declination).to be_within(0.001).of(0.38333384764823003)
    end
  end

  describe 'lstm method' do
    it "should return local standard time meridian in degrees" do
      expect(sun.lstm).to eq(150)
    end
  end

  describe 'vector instance method' do
    it "should return correct value for sun.vector[:x]" do
      expect(sun.vector[:x]).to be_within(0.001).of(0.422625918)
      expect(sun.vector[:y]).to be_within(0.001).of(0.903598645841)
      expect(sun.vector[:z]).to be_within(0.001).of(0.0699772)
    end
  end
end
