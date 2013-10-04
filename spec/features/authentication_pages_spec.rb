require 'spec_helper'

describe "Authentication" do
  subject { page }

  describe "signin page" do# <<<
    before { visit signin_path }

    it { should have_selector('h1', text: 'Sign in')}
    it { should have_selector('title', text: 'Sign in')}

    describe "with invalid input" do
      before { click_button "Sign in" }

      it { should have_selector('title', text: 'Sign in')}
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid input" do
      let(:account) { FactoryGirl.create(:account) }
      before { sign_in account }

      it { should have_selector('title', text: account.username) }
      it { should have_link('Accounts', href: accounts_path) }
      it { should have_link('Account', href: account_path(account)) }
      it { should have_link('Settings', href: edit_account_path(account)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }

      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
        it { should_not have_link('Settings', href: edit_account_path(account)) }
      end

    end

  end# >>>
  describe "authorization" do# <<<
    describe "for non-signed-in accounts" do
      let(:account) { FactoryGirl.create(:account) }

      describe "when attempting to visit a protected page" do
        before { sign_in account }
        
        describe "after signing in" do
          it "should render the desired protected page" do
            page.should have_selector('title', text: 'Edit account')
          end
        end
      end

      describe "in the accounts controller" do
        describe "visiting the edit page" do
          before { visit edit_account_path(account) }
          it { should have_selector('title', text: "Sign in") }
        end

        describe "submitting to the update action" do
          before { put account_path(account) }
          specify { response.should redirect_to(signin_path) }
        end
      end

      describe "visiting the account index" do
        before { visit accounts_path }
        it { should have_selector('title', text: 'Sign in') }
      end

    end #end for non-signed-in accounts

    describe "as wrong account" do
      let(:account) { FactoryGirl.create(:account) }
      let(:wrong_account) { FactoryGirl.create(:account, username: 'wrong_username') }
      before { sign_in account }

      describe "visiting accounts#edit page" do
        before { visit edit_account_path(wrong_account) }
        it { should_not have_selector('title', text: full_title('Edit account')) }
      end

      describe "submitting a PUT request to the accounts#update aciton" do
        before { put account_path(wrong_account) }
        specify { response.should redirect_to(root_path) }
      end

    end
  end #end authorization# >>>
end #end authentication
