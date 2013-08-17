require 'spec_helper'

describe "Postcodes" do
  let(:base_title) { "Solario" }
  let(:postcode) { FactoryGirl.create(:postcode) }
  subject { page }

  shared_examples_for "all postcode pages" do
    it { should have_selector('h1', text: heading) }
  end
  describe 'index page' do# <<<
    let(:heading) { 'Postcodes' }
    before { visit postcodes_path }

    it_should_behave_like 'all postcode pages'
    it { should have_title(full_title('Postcodes')) }

    it "should list each postcode" do
      Postcode.all.each do |postcode|
        page.should have_selector('td', text: postcode.postcode)
        page.should have_link('Show', href: postcode_path(postcode))
        page.should have_link('Delete', href: postcode_path(postcode))
      end
    end

    it { should have_link 'Add postcode', href: new_postcode_path }
  end# >>>
end
