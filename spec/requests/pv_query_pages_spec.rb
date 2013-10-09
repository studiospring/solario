require 'spec_helper'

#needed to check Devise authentication
include Warden::Test::Helpers
Warden.test_mode!

describe "PvQuery" do
  let(:base_title) { "Solario" }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:postcode) { FactoryGirl.create(:postcode) }
  #necessary because pv_queries_controller calls irradiance method
  let!(:irradiance) { FactoryGirl.create(:irradiance, postcode_id: postcode.id) }
  let!(:pv_query) { FactoryGirl.create(:pv_query, postcode_id: postcode.id) }
  subject { page }

  shared_examples_for "all pv_query pages" do
    it { should have_selector('h1', text: heading) }
  end
  describe 'index page' do# <<<
    let(:heading) { 'Queries' }
    before do
      login_as(admin, :scope => :user)
      visit pv_queries_path
    end

    it_should_behave_like 'all pv_query pages'
    it { should have_title(full_title('Queries')) }

    it "should list each query" do
      PvQuery.all.each do |query|
        page.should have_selector('td', text: query.postcode_id)
        page.should have_link('Show', href: pv_query_path(query))
        page.should have_link('Delete', href: pv_query_path(query))
        expect { click_link 'Delete', href: pv_query_path(query) }.to change(PvQuery, :count).by(-1)
      end
    end

    #ensure non-logged-in users cannot see this page, but does not differentiate
    #between admin and non-admin
    describe 'when not logged in' do
      before do
        logout :user
        visit pv_queries_path
      end
      
      it "should redirect to sign-in page" do
        page.should have_selector("h1", text: "Sign in")
      end
    end

  end# >>>
  describe 'new page' do# <<<
    let(:heading) { 'Find your solar output' }
    let(:submit) { 'Get results' }
    before { visit new_pv_query_path }

    it_should_behave_like 'all pv_query pages'
    it { should have_title(full_title(heading)) }
    it { should have_button('Get results') }

    describe 'with invalid inputs' do
      it "should not create a new pv_query" do
        expect { click_button submit }.not_to change(PvQuery, :count)
      end

      describe "after submitting" do
        before { click_button submit }
        it_should_behave_like 'all pv_query pages'
        it { should have_selector("div.alert.alert-error", text: "error") }
      end
    end

    describe 'with valid inputs' do
      before do
        fill_in "Postcode", with: 1234
        fill_in "Tilt", with: 15
        fill_in "Bearing", with: 15
        fill_in "Panel size", with: 15
      end

      it "should create a new pv_query" do
        expect { click_button submit }.to change(PvQuery, :count).by(1)
      end
      it "should create a new panel" do
        expect { click_button submit }.to change(Panel, :count).by(1)
      end

      describe 'after saving the pv_query' do
        before { click_button submit }

        it { should have_title("Results") }
        it { should have_selector("div.alert.alert-success", text: "Pv query created") }
      end
    end

  end# >>>
  describe 'show page' do# <<<
    let(:heading) { 'Pv_query' }
    before do 
      login_as(admin, :scope => :user)
      visit pv_query_path(pv_query)
    end

    it_should_behave_like 'all pv_query pages'
    it { should have_title(full_title('Pv_query')) }

    it { should have_content pv_query.postcode_id }

    it { should have_link 'List of Pv_queries', href: pv_queries_path }
    it { should have_link 'Edit', href: edit_pv_query_path(pv_query) }
    Warden.test_reset! 
  end# >>>
  describe 'results page' do# <<<
    let(:heading) { 'Results' }
    before { visit results_pv_query_path(pv_query) }

    it_should_behave_like 'all pv_query pages'
    it { should have_title(full_title(heading)) }


  end# >>>
  describe 'edit page' do# <<<
    let(:heading) { 'Edit pv_query' }
    let(:submit) { "Update Pv query" }
    before do 
      login_as(admin, :scope => :user)
      visit edit_pv_query_path(pv_query)
    end

    it_should_behave_like 'all pv_query pages'
    it { should have_title(full_title(heading)) }
    it { should have_button("Update Pv query") }

    describe 'with invalid inputs' do
      before do
        fill_in "Postcode", with: " "
        click_button submit 
      end

      describe "error message" do
        it_should_behave_like 'all pv_query pages'
        it { should have_content('error') }
      end
    end

    describe 'with valid inputs' do
      before do
        fill_in "Postcode", with: 130
      end
    end

    describe 'after saving the pv_query' do
      before { click_button submit }

      it { should have_selector('h1', text: "Pv_query") }
      it { should have_selector("div.alert-success", text: 'Pv query updated') }
    end
    Warden.test_reset! 
  end# >>>
end
