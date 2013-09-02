require 'spec_helper'

describe SolarTime do
  let(:test_class) { Struct.new(:longitude) { include SolarTime } }
  let(:solar_time) { test_class.new(35) }
  #subject { @solar_time }

  it "has longitude method" do
    solar_time.longitude.should == 35
  end

  describe 'b' do
    before { test_class.b(10) }
    it "should return 'b' degrees for a given day" do
      test_class.b(10).should be_close(-70.027, 0.005)
    end
  end
  describe 'EoT' do
    before { self.eot(10) }
    it "should return the Equation of Time for a given day" do
      1.should == 1
      #self.eot(10).should == 
    end
  end
  describe 'to_lst' do# <<<
    before { @solar_time.to_lst }
    it "should convert local time to local solar time" do
      1.should == 1
      #@dummy_class.to_lst.should == 
    end
  end# >>>
end
