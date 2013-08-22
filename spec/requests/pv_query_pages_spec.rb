require 'spec_helper'

describe "PvQuery" do
  let(:base_title) { "Solario" }
  let(:pv_query) { FactoryGirl.create(:pv_query) }
  subject { page }

  shared_examples_for "all pv_query pages" do
    it { should have_selector('h1', text: heading) }
  end
  describe 'index page' do# <<<
    let(:heading) { 'Queries' }
    before { visit pv_queries_path }

    it_should_behave_like 'all pv_query pages'
    it { should have_title(full_title('Queries')) }

    it "should list each query" do
      PvQuery.all.each do |query|
        page.should have_selector('td', text: query.postcode)
        page.should have_link('Show', href: pv_query_path(query))
        page.should have_link('Delete', href: pv_query_path(query))
        expect { click_link 'Delete', href: pv_query_path(query) }.to change(PvQuery, :count).by(-1)
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

      describe "error message" do
        before { click_button submit }
        it_should_behave_like 'all pv_query pages'
        it { should have_content('error') }
      end
    end

    describe 'with valid inputs' do
      before do
        fill_in "Postcode", with: pv_query.postcode
      end

      it "should create a new pv_query" do
        expect { click_button submit }.to change(PvQuery, :count).by(1)
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
    before { visit pv_query_path(pv_query) }

    it_should_behave_like 'all pv_query pages'
    it { should have_title(full_title('Pv_query')) }

    it { should have_content pv_query.postcode }

    it { should have_link 'List of Pv_queries', href: pv_queries_path }
    it { should have_link 'Edit', href: edit_pv_query_path(pv_query) }
  end# >>>
end
