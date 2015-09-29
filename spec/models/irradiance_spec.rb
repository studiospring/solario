require 'rails_helper'

describe Irradiance do
  let(:postcode) { FactoryGirl.create(:postcode) }
  let(:pv_query) { postcode.pv_queries.create() }
  let!(:irradiance) do
    FactoryGirl.create(:irradiance, :postcode_id => pv_query.postcode_id)
  end

  before do
    pv_query.panels.create(:tilt => 80,
                           :bearing => 180,
                           :panel_size => 3.5,
                          )
  end

  subject { irradiance }

  it { should respond_to(:direct) }
  it { should respond_to(:diffuse) }
  it { should respond_to(:postcode_id) }
  it { should respond_to(:postcode) }

  specify { expect(subject.postcode).to eq(postcode) }

  it { should be_valid }

  # validation
  describe 'when direct is not present' do
    before { irradiance.direct = ' ' }
    it { should_not be_valid }
  end

  describe 'when diffuse is not present' do
    before { irradiance.diffuse = ' ' }
    it { should_not be_valid }
  end

  #
  # prevents form from being submitted
  # describe "when pv_query_id is not present" do
  # before { @irradiance.pv_query_id = nil }
  # it { should_not be_valid }
  # end
  describe 'irradiance.time_zone_corrected_dni method' do
    it "should return trimmed string" do
      expect(pv_query.postcode.irradiance.time_zone_corrected_dni[1]).to eq("1.66")
    end
  end
end
