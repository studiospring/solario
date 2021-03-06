require 'rails_helper'

describe Postcode do
  let(:postcode) do
    Postcode.new(
      :pcode => 4321,
      :suburb => 'Simsville',
      :state => 'WA',
      :latitude => -12.123123,
      :longitude => 123.456789,
      :urban => false,
    )
  end

  subject { postcode }

  it { should respond_to(:pcode) }
  it { should respond_to(:suburb) }
  it { should respond_to(:state) }
  it { should respond_to(:latitude) }
  it { should respond_to(:longitude) }
  it { should respond_to(:urban) }
  it { should respond_to(:pv_queries) }

  it { should be_valid }

  describe 'when postcode is not present' do
    before { postcode.pcode = ' ' }
    it { should_not be_valid }
  end

  describe 'when postcode is the wrong length' do
    before { postcode.pcode = '12345' }
    it { should_not be_valid }
  end

  describe 'when postcode is not a number' do
    before { postcode.pcode = 'abcd' }
    it { should_not be_valid }
  end

  describe 'when suburb is not present' do
    before { postcode.suburb = ' ' }
    it { should_not be_valid }
  end

  describe 'when state is not present' do
    before { postcode.state = ' ' }
    it { should_not be_valid }
  end

  describe 'when state is not on list' do
    before { postcode.state = 'ABC' }
    it { should_not be_valid }
  end

  describe 'when latitude is not present' do
    before { postcode.latitude = ' ' }
    it { should_not be_valid }
  end

  # problem with bigdecimal or negative values?
  # describe 'when latitude is outside range' do
  # before { postcode.latitude = 42 }
  # it { should_not be_valid }
  # end

  describe 'when latitude is too long' do
    before { postcode.latitude = -12.45678911 }
    it { should_not be_valid }
  end

  describe 'when longitude is not present' do
    before { postcode.longitude = ' ' }
    it { should_not be_valid }
  end

  describe 'when longitude is outside range' do
    before { postcode.longitude = 12 }
    it { should_not be_valid }
  end

  describe 'when longitude is too long' do
    before { postcode.longitude = -12.1111111 }
    it { should_not be_valid }
  end

  describe 'pv_query associations' do
    before { postcode.save }
    let(:pv_query) { FactoryGirl.create(:pv_query, :postcode => postcode) }
  end

  describe 'update_urban?' do
    describe 'when urban attr is false' do
      let(:results) do
        [{:postcode => 4321},
         {:postcode => 4321},
         {:postcode => 4321},
         {:postcode => 4321},
         {:postcode => 4321},
        ]
      end

      before do
        postcode.update_urban(results) if postcode.update_urban?(results)
      end

      it "should update urban attr to 'true' if more than 4 pv systems are found" do
        expect(postcode.urban).to be(true)
      end
    end

    describe 'when urban attr is true' do
      let(:results) do
        [
          {:postcode => 4321},
          {:postcode => 4321},
          {:postcode => 4321},
          {:postcode => 4321}
        ]
      end

      before do
        postcode.urban = true
        postcode.update_urban(results) if postcode.update_urban?(results)
      end

      it "should update urban attr to 'false' if fewer than 5 pv systems are found" do
        expect(postcode.urban).to be(false)
      end
    end
  end
end
