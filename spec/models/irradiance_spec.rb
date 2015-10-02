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

  describe 'validation' do
    it { should be_valid }

    context 'when direct is not present' do
      before { irradiance.direct = ' ' }
      it { should_not be_valid }
    end

    context 'when diffuse is not present' do
      before { irradiance.diffuse = ' ' }
      it { should_not be_valid }
    end
  end

  # prevents form from being submitted
  # describe "when pv_query_id is not present" do
  # before { irradiance.pv_query_id = nil }
  # it { should_not be_valid }
  # end

  describe 'irradiance.tz_corrected_irradiance method' do
    let(:tz_corrected) do
      pv_query.postcode.irradiance.tz_corrected_irradiance('direct')
    end

    context 'when the state is NSW' do
      it "should return trimmed string" do
        expect(tz_corrected[11][-2]).to eq(1.16)
      end
    end

    context 'when the state is SA' do
      before { postcode.state = 'SA' }

      it "should return trimmed string" do
        expect(tz_corrected[0][8]).to eq(8.06)
      end
    end

    context 'when the state is WA' do
      before { postcode.state = 'WA' }

      it "should return trimmed string" do
        expect(tz_corrected[0][4]).to eq(7.54)
      end
    end
  end
end
