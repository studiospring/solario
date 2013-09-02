require 'spec_helper'

describe SolarTime do
  let(:test_class) { Struct.new(:longitude) { include SolarTime } }
  before { @solar_time = test_class.new(35) }
  subject { @solar_time }

  it "dummy instance has longitude attribute" do
    @solar_time.longitude.should == 35
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
        1.should == 1
        #self.eot(10).should == 
      end
    end
    
  end
  describe 'instance method' do
    describe 'to_lst' do# <<<
      before { @solar_time.to_lst }
      it "should convert local time to local solar time" do
        1.should == 1
        #@dummy_class.to_lst.should == 
      end
    end# >>>
  end
end
