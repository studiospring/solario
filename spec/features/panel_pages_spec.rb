require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

describe "Panels" do
  let(:base_title) { "Solario" }
  let(:panel) { FactoryGirl.create(:panel) }
  let(:admin) { FactoryGirl.create(:admin) }
  subject { page }

  shared_examples_for "all panel pages" do
    it { should have_selector('h1', :text => heading) }
  end

  before do
    login_as(admin, :scope => :user)
  end

  describe 'index page' do
    let(:heading) { 'Panels' }
    before { visit panels_path }

    it_should_behave_like 'all panel pages'
    it { should have_title(full_title(heading)) }

    it "should list each panel" do
      Panel.all.each do |panel|
        page.should have_selector('td', :text => panel)
        page.should have_link('Show', :href => panel_path(panel))
        page.should have_link('Delete', :href => panel_path(panel))
        expect { click_link 'Delete', :href => panel_path(panel) }.
          to change(Panel, :count).by(-1)
      end
    end

    it { should have_link 'Add panel', :href => new_panel_path }
  end

  describe 'show page' do
    let(:heading) { 'Panel' }
    let(:heading) { 'Panel' }
    before { visit panel_path(panel) }

    it_should_behave_like 'all panel pages'
    it { should have_title(full_title(heading)) }
    it { should have_content panel.bearing }
    it { should have_link 'Edit', :href => edit_panel_path(panel) }
  end

  describe 'edit page' do
    let(:heading) { 'Update panel' }
    let(:submit) { "Update Panel" }
    before { visit edit_panel_path(panel) }

    it_should_behave_like 'all panel pages'
    it { should have_title(full_title(heading)) }
    it { should have_button('Update Panel') }

    describe 'with invalid inputs' do
      before do
        fill_in "Tilt", :with => " "
        click_button submit
      end

      describe "error message" do
        it_should_behave_like 'all panel pages'
        it { should have_content('error') }
      end
    end

    describe 'with valid inputs' do
      let(:new_panel_size) { 244 }

      before do
        fill_in "Panel size", :with => 244
        click_button submit
      end

      specify { expect(panel.reload.panel_size).to eq new_panel_size }
      it { should have_selector('h1', :text => 'Panel') }
      it { should have_selector("div.alert-success", :text => "Panel updated") }
    end
  end
end
