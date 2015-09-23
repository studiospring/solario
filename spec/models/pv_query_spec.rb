require 'rails_helper'

describe PvQuery do
  # prevent tests from failing because of postcode_to_postcode_id callback
  # PvQuery.skip_callback(:validation, :before, :postcode_to_postcode_id)
  let(:postcode) { FactoryGirl.create(:postcode) }
  before do
    @pv_query = postcode.pv_queries.create()
    @pv_query.panels.create(:tilt => 80, :bearing => 180, :panel_size => 3.5)
  end
  let!(:irradiance) { FactoryGirl.create(:irradiance, :postcode_id => @pv_query.postcode_id) }

  subject { @pv_query }

  it { should respond_to(:postcode_id) }
  it { should respond_to(:postcode) }
  it { should respond_to(:panels) }
  specify { expect(subject.postcode).to eq(postcode) }

  it { should be_valid }

  describe 'panel association' do
    it "should return panel attribute" do
      expect(@pv_query.panels.first.tilt).to eq(80)
    end
  end

  describe 'when postcode_id is not present' do
    before { @pv_query.postcode_id = nil }
    it { should_not be_valid }
  end

  describe 'when postcode_id is not a number' do
    before { @pv_query.postcode_id = 'abcd' }
    it { should_not be_valid }
  end

  describe 'panel association' do
    before do
      @pv_query.save
    end

    let!(:panel) { FactoryGirl.create(:panel, :pv_query => @pv_query) }

    it "should destroy associated panels" do
      panels = @pv_query.panels.to_a
      @pv_query.destroy
      expect(panels).not_to be_empty

      panels.each do |panel|
        expect(Panel.where(:id => panel.id)).to be_empty
      end
    end
  end

  describe 'empirical_output_pa' do
    it "should return the correct value" do
      expect(@pv_query.empirical_output_pa(100)).to eq(45_500)
    end
  end

  describe 'system_watts' do
    it "should calculate the correct value" do
      expect(@pv_query.system_watts).to eq(455)
    end
  end

  describe 'output_pa_array' do
    it "should return totals of dni values for entire pv_query" do
      # broken, panel.dni_received_pa(dni_pa) returns wrong value in tests only
      expect(@pv_query.output_pa_array).to eq('1 2')
    end

    describe 'when no associated postcode is found' do
      before { @pv_query.postcode = nil }

      it "should not raise an error" do
        expect { @pv_query.output_pa_array }.not_to raise_error
      end
    end
  end

  describe 'output_pa_array' do
    it "should return the volume under the graph" do
      expect(@pv_query.output_pa_array).to eq('1234')
    end
  end

  describe 'irradiance.time_zone_corrected_dni method' do
    it "should return trimmed string" do
      expect(@pv_query.postcode.irradiance.time_zone_corrected_dni[0..8]).to eq("0.50 1.66")
    end
  end

  describe 'pvo_search_params' do
    it "should return string of search params" do
      expect(@pv_query.pvo_search_params).to eq("1234 +S")
    end
  end

  describe 'pvo_search_distance' do
    it "should return optimal search distance" do
      expect(@pv_query.pvo_search_distance).to eq('25km')
    end
  end

  describe 'pvo_orientation' do
    it "should return orientation as string" do
      expect(@pv_query.pvo_orientation).to eq('S')
    end
  end

  describe 'northmost_facing_panel' do
    before { @pv_query.panels.create(:tilt => 40, :bearing => 30, :panel_size => 4.4) }

    it "should return northmost panel object" do
      expect(@pv_query.panels.count).to eq(2)
      expect(@pv_query.northmost_facing_panel.bearing).to eq(30)
    end
  end
end
