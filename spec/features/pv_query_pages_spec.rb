require 'spec_helper'

describe "PV Query" do
  let(:base_title) { "Solario" }
  #let(:postcode) { FactoryGirl.create(:postcode) }
  #necessary because pv_queries_controller calls irradiance method
  #let!(:irradiance) { FactoryGirl.create(:irradiance, postcode_id: postcode.id) }
  #let!(:pv_query) { FactoryGirl.create(:pv_query, postcode_id: postcode.id) }
  subject { page }

  describe 'new page', js: true do# <<<
    let(:heading) { 'Average annual panel output' }
    let(:submit) { 'view output' }
    before do
      visit new_pv_query_path
    end
    describe 'with valid inputs' do
      before do
        fill_in "Postcode", with: 1234
        fill_in "Bearing", with: 15
        fill_in "Tilt", with: 15
      end
    end
    describe "after clicking 'add panel'" do
      before { click_link 'add panel' }
      it { should have_selector("input#pv_query_panels_attributes_1_bearing") }

      describe "and clicking 'remove panel'" do
        before { click_link 'remove panel' }
        it { should_not have_selector("input#pv_query_panels_attributes_1_bearing") }
      end
    end
    describe 'with invalid inputs' do
      before do
        fill_in "Postcode", with: 123
        fill_in "Bearing", with: '1234'
        fill_in "Tilt", with: ''
        fill_in "Area", with: ''
        click_button submit
      end
      #test incorrectly fails with alphabet
      it { should have_selector("label.alert-warning",
                                text: "Please enter at least 4 characters.") }
      it { should have_selector("label.alert-warning",
                                text: "Please enter a value less than or equal to 360.") }
      it { should have_selector("label.alert-warning",
                                text: "This field is required.") }
      it { should have_selector("label.alert-warning",
                                text: "This field is required.") }

      it { should_not have_selector('h2', text: heading) }
    end
    
  end# >>>
  describe 'results page, js: true' do# <<<
    let(:heading) { 'Average annual panel output' }
    let(:submit) { 'view output' }
    before do
      visit new_pv_query_path
    end
    describe 'with valid inputs'do
      before do
        fill_in "Postcode", with: 1234
        fill_in "Bearing", with: 15
        fill_in "Tilt", with: 15
        fill_in "Area", with: 15
        click_button submit
      end
      #it { should have_selector('h2', text: heading) }

      #it "should create a new pv_query" do
        #expect { click_button submit }.to change(PvQuery, :count).by(1)
      #end
      #it "should create a new panel" do
        #expect { click_button submit }.to change(Panel, :count).by(1)
      #end

     #it { should have_selector("div.output_pa") }
      #it { should have_link 'Logout', href: destroy_user_session_path }

      #describe 'and logout' do
        #before { click_link "Logout" }
        #it { should have_link 'Login' }
      #end
    end
  end# >>>
end
