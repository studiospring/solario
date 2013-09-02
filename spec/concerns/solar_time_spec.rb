require 'spec_helper'

describe SolarTime do
  let(:test_class) { Struct.new(:longitude) { include SolarTime } }
  before { @solar_time = test_class.new(135) }
  subject { @solar_time }

  it "dummy instance has longitude attribute" do
    @solar_time.longitude.should == 135
  end

  describe 'class method' do
    describe 'b' do
      before { test_class.b(10) }
      it "should return 'b' degrees for a given day" do
        test_class.b(10).should be_close(-1.222, 0.002)
      end
    end
    describe 'EoT' do
      before { test_class.eot(10) }
      it "should return the Equation of Time for a given day" do
        test_class.eot(10).should be_close(-7.499, 0.002)
      end
    end
    
  end
  describe 'instance method' do
    describe 'time correction factor' do
      before { @solar_time.time_correction(10) }
      it "should correct the time wrt day and position" do
        @solar_time.time_correction(10).should be_close(-67.499, 0.02)
      end
    end
    describe 'to_lst' do# <<<
      before { @solar_time.to_lst(14, -67.499) }
      it "should convert local time to local solar time" do
        @solar_time.to_lst(14, -67.499).should be_close(12.88, 0.01)
      end
    end# >>>
  end
end
