require 'spec_helper'

describe "<%= class_name.pluralize %>" do
  let(:base_title) { "Solario" }
  let(:<%= singular_table_name %>) { FactoryGirl.create(:<%= singular_table_name %>) }
  subject { page }

  shared_examples_for "all <%= singular_table_name %> pages" do
    it { should have_selector('h1', text: heading) }
  end
  describe 'index page' do# <<<
    let(:heading) { '<%= class_name.pluralize %>' }
    before { visit <%= plural_table_name %>_path }

    it_should_behave_like 'all <%= singular_table_name %> pages'
    it { should have_title(full_title(heading)) }

    it "should list each <%= singular_table_name %>" do
      <%= class_name %>.all.each do |<%= singular_table_name %>|
        page.should have_selector('td', text: <%= singular_table_name %>)
        page.should have_link('Show', href: <%= singular_table_name %>_path(<%= singular_table_name %>))
        page.should have_link('Delete', href: <%= singular_table_name %>_path(<%= singular_table_name %>))
        expect { click_link 'Delete', href: <%= singular_table_name
          %>_path(<%= singular_table_name %>) }.to change(<%= class_name %>, :count).by(-1)
      end
    end

    it { should have_link 'Add <%= singular_table_name %>', href: new_<%= singular_table_name %>_path }
  end# >>>
  describe 'new page' do# <<<
    let(:heading) { 'Add <%= class_name %>' }
    let(:submit) { "Add <%= class_name %>" }
    before { visit new_<%= singular_table_name %>_path }

    it_should_behave_like 'all <%= singular_table_name %> pages'
    it { should have_title(full_title(heading)) }
    it { should have_button("Add <%= human_name %>") }

    describe 'with invalid inputs' do
      it "should not create a new <%= singular_table_name %>" do
        expect { click_button submit }.not_to change(<%= class_name %>, :count)
      end

      describe "error message" do
        before { click_button submit }
        it_should_behave_like 'all <%= singular_table_name %> pages'
        it { should have_content('error') }
      end
    end

    describe 'with valid inputs' do
      before do
        #TODO
        #fill_in 
      end

      it "should create a new <%= singular_table_name %>" do
        expect { click_button submit }.to change(<%= class_name %>, :count).by(1)
      end
    end

    describe 'after saving the <%= singular_table_name %>' do
      before { click_button submit }

      it { should have_selector('h1', text: "<%= singular_table_name %>") }
      it { should have_selector("div.alert-success", text: "New <%= singular_table_name %> created") }
    end
    it { should have_link 'List of <%= table_name.capitalize %>', href: <%= table_name %>_path }
  end# >>>
  describe 'show page' do# <<<
    let(:heading) { '<%= class_name %>' }
    let(:heading) { '<%= class_name %>' }
    before { visit <%= singular_table_name %>_path(<%= singular_table_name %>) }

    it_should_behave_like 'all <%= singular_table_name %> pages'
    it { should have_title(full_title(heading)) }

    #it { should have_content postcode.pcode }

    it { should have_link 'List of <%= table_name.capitalize %>', href: <%= table_name %>_path }
    it { should have_link 'Edit', href: edit_<%= singular_table_name %>_path(<%= singular_table_name %>) }
  end# >>>
  describe 'edit page' do# <<<
    let(:heading) { 'Update <%= class_name %>' }
    let(:submit) { "Update <%= class_name %>" }
    before { visit edit_<%= singular_table_name %>_path(<%= singular_table_name %>) }

    it_should_behave_like 'all <%= singular_table_name %> pages'
    it { should have_title(full_title(heading)) }
    it { should have_button('Update <%= class_name %>') }

    describe 'with invalid inputs' do
      before do
        #TODO
        fill_in "", with: " "
        click_button submit 
      end

      describe "error message" do
        it_should_behave_like 'all <%= singular_table_name %> pages'
        it { should have_content('error') }
      end
    end

    describe 'with valid inputs' do
      let(:new_value)  { "New value" }
      before do
        #TODO
        fill_in "some_attribute", with: 'New value'
        click_button submit
      end
      it { should have_selector('h1', text: "<%= singular_table_name %>") }
      it { should have_selector("div.alert-success", text: "<%= class_name %> updated") }
      specify { expect(<%= singular_table_name %>.reload.some_attribute).to eq new_value }
    end

  end# >>>
end
