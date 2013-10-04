require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

describe "Irradiances" do
  let(:base_title) { "Solario" }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:postcode) { FactoryGirl.create(:postcode) }
  let!(:irradiance) { FactoryGirl.create(:irradiance, postcode_id: postcode.id) }
  subject { page }

  shared_examples_for "all irradiance pages" do
    it { should have_selector('h1', text: heading) }
  end

  before do 
    login_as(admin, :scope => :user)
  end
  describe 'index page' do# <<<
    let(:heading) { 'Irradiances' }
    before { visit irradiances_path }

    it_should_behave_like 'all irradiance pages'
    it { should have_title(full_title(heading)) }

    it "should list each irradiance" do
      Irradiance.all.each do |irradiance|
        page.should have_selector('td', text: postcode)
        page.should have_link('Show', href: irradiance_path(irradiance))
        page.should have_link('Delete', href: irradiance_path(irradiance))
        expect { click_link 'Delete', href: irradiance_path(irradiance) }.to change(Irradiance, :count).by(-1)
        expect { click_link 'Delete', href: irradiance_path(irradiance) }.not_to change(Postcode, :count).by(-1)
      end
    end

    it { should have_link 'Add irradiance', href: new_irradiance_path }
  end# >>>
  describe 'new page' do# <<<
    let(:heading) { 'Add Irradiance' }
    let(:submit) { "Add Irradiance" }
    before { visit new_irradiance_path }

    it_should_behave_like 'all irradiance pages'
    it { should have_title(full_title(heading)) }
    it { should have_button("Add Irradiance") }

    describe 'with invalid inputs' do
      it "should not create a new irradiance" do
        expect { click_button submit }.not_to change(Irradiance, :count)
      end

      describe "error message" do
        before { click_button submit }
        it_should_behave_like 'all irradiance pages'
        it { should have_content('error') }
      end
    end

    describe 'with valid inputs' do
      before do
        fill_in 'Direct irradiance', with: irradiance.direct
        fill_in 'Diffuse irradiance', with: irradiance.diffuse
        fill_in 'Postcode_id', with: irradiance.postcode_id
      end

      it "should create a new irradiance" do
        expect { click_button submit }.to change(Irradiance, :count).by(1)
      end
      it "should associate with the correct postcode" do
        pending 'figuring out how to do it'
      end
    end

    describe 'after saving the irradiance' do
      before { click_button submit }

      it { should have_selector('h1', text: "Irradiance") }
      it { should have_selector("div.alert-success", text: "New irradiance created") }
    end
    it { should have_link 'List of Irradiances', href: irradiances_path }
  end# >>>
  describe 'show page' do# <<<
    let(:heading) { 'Irradiance' }
    let(:heading) { 'Irradiance' }
    before { visit irradiance_path(irradiance) }

    it_should_behave_like 'all irradiance pages'
    it { should have_title(full_title(heading)) }

    #it { should have_content postcode.pcode }

    it { should have_link 'List of Irradiances', href: irradiances_path }
    it { should have_link 'Edit', href: edit_irradiance_path(irradiance) }
  end# >>>
  describe 'edit page' do# <<<
    let(:heading) { 'Update Irradiance' }
    let(:submit) { "Update Irradiance" }
    before { visit edit_irradiance_path(irradiance) }

    it_should_behave_like 'all irradiance pages'
    it { should have_title(full_title(heading)) }
    it { should have_button('Update Irradiance') }

    describe 'with invalid inputs' do
      before do
        #TODO
        fill_in "Direct irradiance", with: ""
        click_button submit 
      end

      describe "error message" do
        it_should_behave_like 'all irradiance pages'
        it { should have_content('error') }
      end
    end

    describe 'with valid inputs' do
      before do
        #TODO
        fill_in "Direct irradiance", with: "123"
        fill_in "Diffuse irradiance", with: "321"
        #fill_in "Postcode_id", with: "3211"
      end

    end

    describe 'after saving the irradiance' do
      before { click_button submit }

      it { should have_selector('h1', text: "Irradiance") }
      it { should have_selector("div.alert-success", text: "Irradiance updated") }
    end
  end# >>>
end
