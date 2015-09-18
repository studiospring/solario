require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

describe "Irradiances" do
  let(:base_title) { "Solario" }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:postcode) { FactoryGirl.create(:postcode) }
  let!(:irradiance) { FactoryGirl.create(:irradiance, :postcode_id => postcode.id) }
  subject { page }

  shared_examples_for "all irradiance pages" do
    it { expect(page).to have_selector('h1', :text => heading) }
  end

  before do
    login_as(admin, :scope => :user)
  end

  describe 'index page' do
    let(:heading) { 'Irradiances' }
    before { visit irradiances_path }

    it_should_behave_like 'all irradiance pages'
    it { expect(page).to have_title(full_title(heading)) }

    it "should be able to delete an irradiance" do
      expect { click_link 'Delete', :href => irradiance_path(irradiance) }
        .to change(Irradiance, :count).by(-1)
    end

    it "should not be able to delete a postcode" do
      expect { click_link 'Delete', :href => irradiance_path(irradiance) }
        .not_to change(Postcode, :count)
    end

    it "should list each irradiance" do
      Irradiance.all.each do |irradiance|
        expect(page).to have_selector('td', :text => postcode.pcode)
        expect(page).to have_link('Show', :href => irradiance_path(irradiance))
        expect(page).to have_link('Delete', :href => irradiance_path(irradiance))
      end
    end

    it { expect(page).to have_link 'Add irradiance', :href => new_irradiance_path }

    describe 'when not logged in' do
      before do
        logout :user
        visit irradiances_path
      end

      it { expect(page).to have_selector("h1", :text => "Sign in") }
    end
  end

  describe 'new page' do
    let(:heading) { 'Add Irradiance' }
    let(:submit) { "Add Irradiance" }
    before { visit new_irradiance_path }

    it_should_behave_like 'all irradiance pages'
    it { expect(page).to have_title(full_title(heading)) }
    it { expect(page).to have_button("Add Irradiance") }

    describe 'with invalid inputs' do
      it "should not create a new irradiance" do
        expect { click_button submit }.not_to change(Irradiance, :count)
      end

      describe "error message" do
        before { click_button submit }
        it_should_behave_like 'all irradiance pages'
        it { expect(page).to have_content('error') }
      end
    end

    describe 'with valid inputs' do
      before do
        fill_in 'Direct irradiance', :with => irradiance.direct
        fill_in 'Diffuse irradiance', :with => irradiance.diffuse
        fill_in 'Postcode_id', :with => irradiance.postcode_id
      end

      it "should create a new irradiance" do
        expect { click_button submit }.to change(Irradiance, :count).by(1)
      end

      describe 'after saving the irradiance' do
        before { click_button submit }

        it { expect(page).to have_selector('h1', :text => "Irradiance") }
        it { expect(page).to have_selector("div.alert-success", :text => "New irradiance created") }
      end

      it "should associate with the correct postcode" do
        skip 'figuring out how to do it'
      end
    end

    describe 'when not logged in' do
      before do
        logout :user
        visit new_irradiance_path
      end

      it { expect(page).to have_selector("h1", :text => "Sign in") }
    end
  end

  describe 'show page' do
    let(:heading) { 'Irradiance' }
    let(:heading) { 'Irradiance' }

    before { visit irradiance_path(irradiance) }

    it_should_behave_like 'all irradiance pages'
    it { expect(page).to have_title(full_title(heading)) }

    # it {expect(page).to have_content postcode.pcode }

    it { expect(page).to have_link 'Edit', :href => edit_irradiance_path(irradiance) }
    describe 'when not logged in' do
      before do
        logout :user
        visit irradiance_path(irradiance)
      end

      it { expect(page).to have_selector("h1", :text => "Sign in") }
    end
  end

  describe 'edit page' do
    let(:heading) { 'Update Irradiance' }
    let(:submit) { "Update Irradiance" }
    before { visit edit_irradiance_path(irradiance) }

    it_should_behave_like 'all irradiance pages'
    it { expect(page).to have_title(full_title(heading)) }
    it { expect(page).to have_button('Update Irradiance') }

    describe 'with invalid inputs' do
      before { fill_in 'Direct irradiance', :with => ' ' }

      it "should not create a new irradiance" do
        expect { click_button submit }.not_to change(Irradiance, :count)
      end

      describe "after submitting" do
        before { click_button submit }

        it_should_behave_like 'all irradiance pages'
        it { expect(page).to have_selector("div.alert.alert-danger", :text => "error") }
      end
    end

    describe 'with valid inputs' do
      let(:new_diffuse)  { "888" }

      before do
        fill_in "Diffuse irradiance", :with => "888"
        click_button submit
      end

      it { expect(page).to have_selector('h1', :text => "Irradiance") }
      it { expect(page).to have_selector("div.alert-success", :text => "Irradiance updated") }
      specify { expect(irradiance.reload.diffuse).to eq new_diffuse }
    end

    describe 'when not logged in' do
      before do
        logout :user
        visit edit_irradiance_path(irradiance)
      end

      it { expect(page).to have_selector("h1", :text => "Sign in") }
    end
  end
end
