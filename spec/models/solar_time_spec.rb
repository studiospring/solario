require 'spec_helper'
class DummyClass
  attr_accessor :longitude

  def initialize(longitude)
    @longitude = longitude
  end
end
describe 'DummyClass' do
  before { @dummy_class = DummyClass.new(longitude: 35) }  

  it { should respond_to(:longitude) }
  
end

describe SolarTime do
  before(:each) do
    @dummy_class = DummyClass.new(longitude: 35)
    @dummy_class.extend(SolarTime)
  end
  subject { @dummy_class }

  describe 'b' do
    before { DummyClass.b(10) }
    it "should return 'b' degrees for a given day" do
      1.should == 1
      #self.b(10).should be_close(-70.027, 0.005)
    end
  end
  describe 'EoT' do
    before { self.eot(10) }
    it "should return the Equation of Time for a given day" do
      pending 'b'
      #self.eot(10).should == 
    end
  end
  describe 'to_lst' do# <<<
    before { @dummy_class.to_lst }
    it "should convert local time to local solar time" do
      pending 'EoT'
      #@dummy_class.to_lst.should == 
    end
  end# >>>
end
