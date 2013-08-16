require 'spec_helper'

describe "Postcodes" do
  subject { page }

  shared_examples_for "all postcode pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_selector('title', text: title) }
  end
  describe 'postcodes page' do
    let(:heading) { 'Postcodes' }
    let(:title) { 'Postcodes' }
    before { visit postcodes_path }

    it_should_behave_like 'all postcode pages'
  end
end
