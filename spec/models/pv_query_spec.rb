require 'spec_helper'

describe PvQuery do
  #prevent tests from failing because of postcode_to_postcode_id callback
  PvQuery.skip_callback(:validation, :before, :postcode_to_postcode_id)
  let(:postcode) { FactoryGirl.create(:postcode) }
  before do
    @pv_query = postcode.pv_queries.build()
  end
  let!(:irradiance) { FactoryGirl.create(:irradiance, postcode_id: @pv_query.postcode_id) }

  subject { @pv_query }

  it { should respond_to(:postcode_id) }
  it { should respond_to(:postcode) }
  its(:postcode) { should eq postcode }
  it { should respond_to(:panels) }

  it { should be_valid }

  describe 'when postcode_id is not present' do# <<<
    before { @pv_query.postcode_id = nil }
    it { should_not be_valid }
  end
  describe 'when postcode_id is not a number' do
    before { @pv_query.postcode_id = 'abcd' }
    it { should_not be_valid }
  end# >>>
  describe 'panel association' do# <<<
    before do
      @pv_query.save
    end
    let!(:panel) { FactoryGirl.create(:panel, pv_query: @pv_query) }

    it "should destroy associated panels" do
      panels = @pv_query.panels.to_a
      @pv_query.destroy
      expect(panels).not_to be_empty
      panels.each do |panel|
        expect(Panel.where(id: panel.id)).to be_empty
      end
    end
  end# >>>
  describe 'avg_output_pa' do# <<<
    it "should return totals of dni values for entire pv_query" do
      #broken, postcode_id cannot be found
      @pv_query.avg_output_pa.should == '1 2'
    end
    describe 'when no associated postcode is found' do
      before { @pv_query.postcode = nil }
      it "should not raise an error" do
        lambda { @pv_query.avg_output_pa }.should_not raise_error
      end
    end
  end# >>>
  describe 'total_annual_output' do
    it "should return the volume under the graph" do
      @pv_query.total_annual_output.should == '1234'
    end
  end
  describe 'time_zone_corrected_dni method' do# <<<
    it "should return trimmed string" do
      @pv_query.postcode.irradiance.time_zone_corrected_dni[0..8].should == "0.50 1.66"
    end
  end# >>>
end
