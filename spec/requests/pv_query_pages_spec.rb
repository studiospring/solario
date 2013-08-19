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
    before { visit pv_query_path }

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
end
