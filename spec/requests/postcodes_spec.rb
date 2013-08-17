require 'spec_helper'

describe "Postcodes" do
  let(:base_title) { "Solario" }
  let(:postcode) { FactoryGirl.create(:postcode) }
  subject { page }

  shared_examples_for "all postcode pages" do
    it { should have_selector('h1', text: heading) }
  end
  describe 'index page' do# <<<
    let(:heading) { 'Postcodes' }
    before { visit postcodes_path }

    it_should_behave_like 'all postcode pages'
    it { should have_title(full_title('Postcodes')) }

    it "should list each postcode" do
      Postcode.all.each do |postcode|
        page.should have_selector('td', text: postcode.postcode)
        page.should have_link('Show', href: postcode_path(postcode))
        page.should have_link('Delete', href: postcode_path(postcode))
        expect { click_link 'Delete', href: postcode_path(postcode) }.to change(Postcode, :count).by(-1)
      end
    end

    it { should have_link 'Add postcode', href: new_postcode_path }
  end# >>>
  describe 'new page' do# <<<
    let(:heading) { 'Add postcode' }
    let(:submit) { "Add Postcode" }
    before { visit new_postcode_path }

    it_should_behave_like 'all postcode pages'
    it { should have_title(full_title(heading)) }

    describe 'with invalid inputs' do
      it "should not create a new postcode" do
        expect { click_button submit }.not_to change(Postcode, :count)
      end

      describe "error message" do
        before { click_button submit }
        it_should_behave_like 'all postcode pages'
        it { should have_content('error') }
      end
    end

    describe 'with valid inputs' do
      before do
        fill_in "Postcode", with: postcode.postcode
        fill_in "Suburb", with: postcode.suburb
        fill_in "State", with: postcode.state
        fill_in "Latitude", with: postcode.latitude
        fill_in "Longitude", with: postcode.longitude
      end

      it "should create a new postcode" do
        expect { click_button submit }.to change(Postcode, :count).by(1)
      end
    end

    describe 'after saving the postcode' do
      before { click_button submit }

      it { should have_title("Postcode") }
      it { should have_selector("div.alert.alert-success", text: "New postcode saved") }
    end
    it { should have_link 'List of postcodes', href: postcodes_path }
  end# >>>
  describe 'show page' do# <<<
    let(:heading) { 'Postcode' }
    before { visit postcode_path(postcode) }

    it_should_behave_like 'all postcode pages'
    it { should have_title(full_title('Postcode')) }

    it { should have_content postcode.postcode }

    it { should have_link 'List of postcodes', href: postcodes_path }
    it { should have_link 'Edit', href: edit_postcode_path(postcode) }
  end# >>>
end
