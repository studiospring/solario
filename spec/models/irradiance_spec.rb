# == Schema Information
#
# Table name: irradiances
#
#  id          :integer          not null, primary key
#  direct      :text
#  diffuse     :text
#  postcode_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Irradiance do
  let(:postcode) { FactoryGirl.create(:postcode) }
  before { @irradiance = postcode.build_irradiance(FactoryGirl.attributes_for(:irradiance)) }
  subject { @irradiance }

  it { should respond_to(:direct) }
  it { should respond_to(:diffuse) }
  it { should respond_to(:postcode_id) }
  it { should respond_to(:postcode) }
  its(:postcode) { should eq postcode }

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
