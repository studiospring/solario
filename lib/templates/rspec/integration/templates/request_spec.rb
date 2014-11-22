require 'spec_helper'

describe "<%= class_name.pluralize %>" do
  let(:base_title) { "Solario" }
  let(:<%= singular_table_name %>) { FactoryGirl.create(:<%= singular_table_name %>) }
  subject { page }

  shared_examples_for "all <%= plural_table_name %> pages" do
    it { should have_selector('h1', text: heading) }
  end
  describe '<%= action %> page' do
    let(:heading) { '<%= class_name %>' }
    before { visit postcodes_path }

    it_should_behave_like 'all postcode pages'
    it { should have_title(full_title('Postcodes')) }

    it "should list each postcode" do
      Postcode.all.each do |postcode|
        page.should have_selector('td', text: postcode.pcode)
        page.should have_link('Show', href: postcode_path(postcode))
        page.should have_link('Delete', href: postcode_path(postcode))
        expect { click_link 'Delete', href: postcode_path(postcode) }.to change(Postcode, :count).by(-1)
      end
    end

    it { should have_link 'Add postcode', href: new_postcode_path }
  end
  describe "GET /<%= table_name %>" do
    it "works! (now write some real specs)" do
<% if webrat? -%>
      visit <%= index_helper %>_path
<% else -%>
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get <%= index_helper %>_path
<% end -%>
      response.status.should be(200)
    end
  end
end
