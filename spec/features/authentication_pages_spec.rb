require 'spec_helper'
#devise tests must be in features directory (not requests) to use Capybara methods

describe "Authentication" do
  let(:base_title) { "Solario" }
  let(:user) { FactoryGirl.create(:user) }
  subject { page }

  shared_examples_for "all authentication pages" do
    it { should have_selector('h1', text: heading) }
    #cannot access helpers without calling 'ApplicationController...'
    it { should have_title(ApplicationController.helpers.full_title(heading)) }
  end
  describe 'admin login page' do# <<<
    let(:heading) { 'Sign in' }
    let(:submit) { "Sign in" }
    before do
      user.admin = true
      visit new_user_session_path
    end

    it_should_behave_like 'all authentication pages'
    it { should have_button(submit) }

    describe 'with invalid inputs' do
      before { click_button submit }
      describe "should have error message" do
        it_should_behave_like 'all authentication pages'
        it { should have_selector("div.alert", text: "Invalid") }
      end
    end

    describe 'with valid inputs' do
      before do
        fill_in 'Username', with: user.username
        fill_in 'Password', with: user.password
        click_button submit
      end
      it { should have_selector("div.alert-notice", text: "Signed in") }
      it { should have_link 'Logout', href: destroy_user_session_path }

      #describe "log the user in" do
      #end
    end

  end# >>>
end
