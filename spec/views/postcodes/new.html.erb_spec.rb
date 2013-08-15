require 'spec_helper'

describe "postcodes/new" do
  before(:each) do
    assign(:postcode, stub_model(Postcode,
      :postcode => 1,
      :suburb => "MyString",
      :state => "MyString",
      :latitude => 1,
      :longitude => 1
    ).as_new_record)
  end

  it "renders new postcode form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", postcodes_path, "post" do
      assert_select "input#postcode_postcode[name=?]", "postcode[postcode]"
      assert_select "input#postcode_suburb[name=?]", "postcode[suburb]"
      assert_select "input#postcode_state[name=?]", "postcode[state]"
      assert_select "input#postcode_latitude[name=?]", "postcode[latitude]"
      assert_select "input#postcode_longitude[name=?]", "postcode[longitude]"
    end
  end
end
