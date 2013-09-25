require 'spec_helper'

describe PvQuery do
  let(:postcode) { FactoryGirl.create(:postcode) }
  before { @pv_query = postcode.pv_queries.build() }
  subject { @pv_query }

  it { should respond_to(:postcode_id) }
  it { should respond_to(:postcode) }
  its(:postcode) { should eq postcode }
  it { should respond_to(:panels) }

  it { should be_valid }

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
    let!(:panel) { FactoryGirl.create(:panel, pv_query: @pv_query) }

    it "should destroy associated panels" do
      panels = @pv_query.panels.to_a
      @pv_query.destroy
      expect(panels).not_to be_empty
      panels.each do |panel|
        expect(Panel.where(id: panel.id)).to be_empty
      end
    end
  end
end
