require 'rails_helper'

describe Panel do
  # prevent tests from failing because of postcode_to_postcode_id callback
  PvQuery.skip_callback(:validation, :before, :postcode_to_postcode_id)

  let(:pv_query) { FactoryGirl.create(:pv_query) }
  let!(:irradiance) { FactoryGirl.create(:irradiance, :postcode_id => pv_query.postcode_id) }
  let!(:panel) { pv_query.panels.build(:tilt => 60, :bearing => 150, :panel_size => 31) }

  subject { panel }

  it { should respond_to(:tilt) }
  it { should respond_to(:bearing) }
  it { should respond_to(:panel_size) }
  it { should respond_to(:pv_query_id) }
  it { should respond_to(:pv_query) }

  specify { expect(subject.pv_query).to eq(pv_query) }

  it { should be_valid }

  # validation
  describe 'when tilt is not present' do
    before { panel.tilt = ' ' }
    it { should_not be_valid }
  end

  describe 'when tilt is too low' do
    before { panel.tilt = -1 }
    it { should_not be_valid }
  end

  describe 'when tilt is too high' do
    before { panel.tilt = 181 }
    it { should_not be_valid }
  end

  describe 'when tilt is not a number' do
    before { panel.tilt = 'cd' }
    it { should_not be_valid }
  end

  describe 'when bearing is not present' do
    before { panel.bearing = ' ' }
    it { should_not be_valid }
  end

  describe 'when bearing is too low' do
    before { panel.bearing = -1 }
    it { should_not be_valid }
  end

  describe 'when bearing is too high' do
    before { panel.bearing = 361 }
    it { should_not be_valid }
  end

  describe 'when bearing is not a number' do
    before { panel.bearing = 'abc' }
    it { should_not be_valid }
  end

  describe 'when panel_size is not present' do
    before { panel.panel_size = ' ' }
    it { should_not be_valid }
  end

  describe 'when panel_size is not a number' do
    before { panel.panel_size = 'abc' }
    it { should_not be_valid }
  end

  # prevents form from being submitted
  # describe "when pv_query_id is not present" do
  # before { panel.pv_query_id = nil }
  # it { should_not be_valid }
  # end

  describe 'possible_watts' do
    it "should calculate correct value" do
      expect(panel.possible_watts).to eq(4030)
    end
  end

  describe 'vector instance method' do
    before { panel.vector }
    it "should return correct value for panel.vector[:x]" do
      # when bearing is 150 deg
      expect(panel.vector[:x]).to be_within(0.001).of(-0.75000)
    end

    it "should return correct value for panel.vector[:y]" do
      # when bearing is 150 deg
      expect(panel.vector[:y]).to be_within(0.01).of(0.433012701)
    end

    it "should return correct value for panel.vector[:z]" do
      # when tilt is 60 deg
      expect(panel.vector[:z]).to be_within(0.001).of(0.5)
    end
  end

  describe 'dni_received_pa method' do
    it "should return correct array" do
      expect(panel.dni_received_pa(irradiance.tz_corrected_irradiance('direct'))[5])
        .to eq(6.82) # correct time_zone difference
    end

    describe 'when no associated postcode is found' do
      before do
        panel.pv_query.postcode = nil
      end

      it "should raise an error" do
        expect(-> { panel.dni_received_pa(irradiance.direct[0..-8]) }).to raise_error
      end
    end
  end

  describe 'dni_hash_received_pa method' do
    # rubocop:disable  Metrics/LineLength
    before do
      @dni_pa = "2.4 4.8 9.6 4.8 2.4 2.2 4.4 8.8 4.4 2.2 2.1 4.2 8.4 4.2 2.1 1.8 3.6 7.2 3.6 1.8 1.5 3.0 6.0 3.0 1.5 1.4 2.8 5.6 2.8 1.4 1.5 3.0 6.0 3.0 1.5 1.8 3.6 7.2 3.6 1.8 2.2 4.4 8.8 4.4 2.2 2.4 4.8 9.6 4.8 2.4 2.6 5.2 10.4 5.2 2.6 2.5 5.0 10.0 5.0 2.5"
    end
    # rubocop:enable  Metrics/LineLength

    it "should return a very big hash" do
      skip 'if this method is really necessary'
      # panel.dni_received_pa(@dni_pa)[0][0].should == BigDecimal('0.4')
    end
  end

  describe 'avg_efficiency method' do
    it "should return correct value" do
      expect(Panel.avg_efficiency(20, 0.98)).to eq(0.83)
    end
  end

  describe 'overall_efficiency' do
    it "should return correct value" do
      expect(Panel.overall_efficiency).to eq(0.14)
    end
  end

  describe 'dni_received method' do
    let(:latitude) { -13 }
    let(:longitude) { 123.123456 }
    let(:state) { 'NSW' }
    let(:sun) { Sun.new(latitude, longitude, state, 1, 12) }
    let(:dni) { 12 }

    it "should return a Fixnum" do
      # No guarantee that the formula is correct, just that the formula works!
      expect(panel.dni_received(sun, dni)).to eq(92.38)
    end
  end
end
