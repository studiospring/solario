require 'spec_helper'

describe "postcodes/index" do
  before(:each) do
    assign(:postcodes, [
      stub_model(Postcode,
        :postcode => 1,
        :suburb => "Suburb",
        :state => "State",
        :latitude => 2,
        :longitude => 3
      ),
      stub_model(Postcode,
        :postcode => 1,
        :suburb => "Suburb",
        :state => "State",
        :latitude => 2,
        :longitude => 3
      )
    ])
  end

  it "renders a list of postcodes" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Suburb".to_s, :count => 2
    assert_select "tr>td", :text => "State".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
