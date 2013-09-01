require 'spec_helper'

describe "Panels" do
  let(:base_title) { "Solario" }
  let(:panel) { FactoryGirl.create(:panel) }
  subject { page }

  shared_examples_for "all panel pages" do
    it { should have_selector('h1', text: heading) }
  end
  describe 'index page' do# <<<
    let(:heading) { 'Panels' }
    before { visit panels_path }

    it_should_behave_like 'all panel pages'
    it { should have_title(full_title(heading)) }

    it "should list each panel" do
      Panel.all.each do |panel|
        page.should have_selector('td', text: panel)
        page.should have_link('Show', href: panel_path(panel))
        page.should have_link('Delete', href: panel_path(panel))
        expect { click_link 'Delete', href: panel_path(panel) }.to change(Panel, :count).by(-1)
      end
    end

    it { should have_link 'Add panel', href: new_panel_path }
  end# >>>
  describe 'show page' do# <<<
    let(:heading) { 'Panel' }
    let(:heading) { 'Panel' }
    before { visit panel_path(panel) }

    it_should_behave_like 'all panel pages'
    it { should have_title(full_title(heading)) }

    it { should have_content panel.bearing }

    it { should have_link 'List of Panels', href: panels_path }
    it { should have_link 'Edit', href: edit_panel_path(panel) }
  end# >>>
  describe 'edit page' do# <<<
    let(:heading) { 'Update panel' }
    let(:submit) { "Update Panel" }
    before { visit edit_panel_path(panel) }

    it_should_behave_like 'all panel pages'
    it { should have_title(full_title(heading)) }
    it { should have_button('Update Panel') }

    describe 'with invalid inputs' do
      before do
        fill_in "Tilt", with: " "
        click_button submit 
      end

      describe "error message" do
        it_should_behave_like 'all panel pages'
        it { should have_content('error') }
      end
    end

    describe 'with valid inputs' do
      before do
        fill_in "Tilt", with: 23
        fill_in "Bearing", with: 360
        fill_in "Panel size", with: 2444
      end

    end

    describe 'after saving the panel' do
      before { click_button submit }

      it { should have_selector('h1', text: 'Panel') }
      it { should have_selector("div.alert-success", text: "Panel updated") }
    end

  end# >>>
end
