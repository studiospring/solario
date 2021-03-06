require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

describe "Postcodes" do
  let(:base_title) { "Solario" }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:postcode) { FactoryGirl.create(:postcode) }
  subject { page }

  shared_examples_for "all postcode pages" do
    it { expect(page).to have_selector('h1', :text => heading) }
  end

  before do
    login_as(admin, :scope => :user)
  end

  describe 'index page' do
    let(:heading) { 'Postcodes' }
    before { visit postcodes_path }

    it_should_behave_like 'all postcode pages'
    it { expect(page).to have_title(full_title('Postcodes')) }

    it "should list each postcode" do
      Postcode.all.each do |postcode|
        expect(page).to have_selector('td', :text => postcode.pcode)
        expect(page).to have_link('Show', :href => postcode_path(postcode))
        expect(page).to have_link('Delete', :href => postcode_path(postcode))
        expect { click_link 'Delete', :href => postcode_path(postcode) }.to change(Postcode, :count).by(-1)
      end
    end

    it { expect(page).to have_link 'Add postcode', :href => new_postcode_path }

    describe 'when not logged in' do
      before do
        logout :user
        visit postcodes_path
      end

      it { expect(page).to have_selector("h1", :text => "Sign in") }
    end
  end

  describe 'new page' do
    let(:heading) { 'Add postcode' }
    let(:submit) { "Add Postcode" }
    before { visit new_postcode_path }

    it_should_behave_like 'all postcode pages'
    it { expect(page).to have_title(full_title(heading)) }
    it { expect(page).to have_button("Add Postcode") }

    describe 'with invalid inputs' do
      it "should not create a new postcode" do
        expect { click_button submit }.not_to change(Postcode, :count)
      end

      describe "error message" do
        before { click_button submit }
        it_should_behave_like 'all postcode pages'
        it { expect(page).to have_content('error') }
      end
    end

    describe 'with valid inputs' do
      before do
        fill_in "Postcode", :with => postcode.pcode
        fill_in "Suburb", :with => postcode.suburb
        fill_in "State", :with => postcode.state
        fill_in "Latitude", :with => postcode.latitude
        fill_in "Longitude", :with => postcode.longitude
        check "Urban"
      end

      it "should create a new postcode" do
        expect { click_button submit }.to change(Postcode, :count).by(1)
      end

      describe 'after saving the postcode' do
        before { click_button submit }

        it { expect(page).to have_selector('h1', :text => "Postcode") }
        it { expect(page).to have_selector("div.alert-success", :text => "Postcode created") }
      end
    end

    describe 'when not logged in' do
      before do
        logout :user
        visit new_postcode_path
      end

      it { expect(page).to have_selector("h1", :text => "Sign in") }
    end
  end

  describe 'show page' do
    let(:heading) { 'Postcode' }
    before { visit postcode_path(postcode) }

    it_should_behave_like 'all postcode pages'
    it { expect(page).to have_title(full_title('Postcode')) }
    it { expect(page).to have_content postcode.pcode }
    it { expect(page).to have_link 'Edit', :href => edit_postcode_path(postcode) }
  end

  describe 'edit page' do
    let(:heading) { 'Update postcode' }
    let(:submit) { "Update Postcode" }
    before { visit edit_postcode_path(postcode) }

    it_should_behave_like 'all postcode pages'
    it { expect(page).to have_title(full_title(heading)) }
    it { expect(page).to have_button("Update Postcode") }

    describe 'with invalid inputs' do
      before do
        fill_in "State", :with => " "
        click_button submit
      end

      describe "error message" do
        it_should_behave_like 'all postcode pages'
        it { expect(page).to have_content('error') }
      end
    end

    describe 'with valid inputs' do
      let(:new_suburb) { "Newville" }

      before do
        fill_in "Postcode", :with => 8888
        fill_in "Suburb", :with => 'Newville'
        fill_in "State", :with => 'WA'
        fill_in "Latitude", :with => 10
        fill_in "Longitude", :with => 130
        check "Urban"
        click_button submit
      end

      it { expect(page).to have_selector('h1', :text => "Postcode") }
      it { expect(page).to have_selector("div.alert-success", :text => 'Postcode updated') }
      specify { expect(postcode.reload.suburb).to eq new_suburb }
    end
  end
end
