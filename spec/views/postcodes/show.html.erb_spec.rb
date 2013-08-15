require 'spec_helper'

describe "postcodes/show" do
  before(:each) do
    @postcode = assign(:postcode, stub_model(Postcode,
      :postcode => 1,
      :suburb => "Suburb",
      :state => "State",
      :latitude => 2,
      :longitude => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/Suburb/)
    rendered.should match(/State/)
    rendered.should match(/2/)
    rendered.should match(/3/)
  end
end
