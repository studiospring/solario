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
    it { should have_title(full_title('Panels')) }

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
  describe 'new page' do# <<<
    let(:heading) { 'Add Panels' }
    let(:submit) { "Add Panel" }
    before { visit new_panel_path }

    it_should_behave_like 'all panel pages'
    it { should have_title(full_title('Panels')) }
    it { should have_button("Add Panel") }

    describe 'with invalid inputs' do
      it "should not create a new panel" do
        expect { click_button submit }.not_to change(Panel, :count)
      end

      describe "error message" do
        before { click_button submit }
        it_should_behave_like 'all panel pages'
        it { should have_content('error') }
      end
    end

    describe 'with valid inputs' do
      before do
          #fill_in 
      end

      it "should create a new panel" do
        expect { click_button submit }.to change(Panel, :count).by(1)
      end
    end

    describe 'after saving the panel' do
      before { click_button submit }

      it { should have_selector('h1', text: "Add panel") }
      it { should have_selector("div.alert-success", text: "New panel saved") }
    end
    it { should have_link 'List of panels', href: panels_path }
  end# >>>
end
