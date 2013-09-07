require 'spec_helper'

describe Irradiance do
  let(:postcode) { FactoryGirl.create(:postcode) }
  before { @irradiance = postcode.irradiance.build(direct: "dummy1", diffuse: "dummy2") }
  subject { @irradiance }

  it { should respond_to(:direct) }
  it { should respond_to(:diffuse) }
  it { should respond_to(:pv_query_id) }
  it { should respond_to(:pv_query) }
  its(:pv_query) { should eq pv_query }

  it { should be_valid }

  #validation
  describe 'when direct is not present' do# <<<
    before { @irradiance.direct = ' ' }
    it { should_not be_valid }
  end
  describe 'when diffuse is not present' do
    before { @irradiance.diffuse = ' ' }
    it { should_not be_valid }
  end
  #prevents form from being submitted
  #describe "when pv_query_id is not present" do
    #before { @irradiance.pv_query_id = nil }
    #it { should_not be_valid }
  #end# >>>
end
