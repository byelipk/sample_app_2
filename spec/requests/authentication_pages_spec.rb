require 'spec_helper'

describe "Authentication" do

  # Define the test subject
  subject { page }

  # TEST: Existence of sign-in page
  describe "signin page" do
    # Follow path to page
    before { visit signin_path }

    # Upon arriving our expectations are that...
    it { should have_selector('h1',    text: 'Sign in') }
    it { should have_selector('title', text: 'Sign in') }
  end

  # TEST: Sign-in process
  describe "signin" do
    
    # Follow path to page...
  	before { visit signin_path }

    # TEST(1A): ...with invalid information.
  	describe "with invalid information" do
      
      # Follow path to page.
  		before { click_button "Sign in" }

      # Upon arriving our expectations are that...
  		it { should have_selector('title', text: 'Sign in') }
  		it { should have_selector('div.alert.alert-error', text: 'Invalid') }

        # TEST(1A): Our ability to navigate the site
  	    describe "after visiting another page" do
         
          # Follow path to page.
          before { click_link "Home" }
         
          # Upon arriving our expectations are that...
          it { should_not have_selector('div.alert.alert-error') }
        end	
  	end

    # ...with valid information.
    describe "with valid information" do

      # Create test user
      let(:user) { FactoryGirl.create(:user) }

      # Fill out form, then follow path to page.
      # Method: sign_in is found in utilities.rb
      before { sign_in user }

      # Our expectations are that...
      it { should have_selector('title',   text: user.name) }
      it { should have_link('Profile',     href: user_path(user)) }
      it { should have_link('Sign out',    href: signout_path) }
      it { should have_link('Settings',    href: edit_user_path(user)) }
      it { should_not have_link('Sign in', href: signin_path) }

      # TEST: The sign-out process
      describe "followed by signout" do

        # Follow path to page.
        before { click_link "Sign out" }

        # Our expectations are that...
        it { should have_link('Sign in') }
      end
    end
  end	

  # TEST: Site-wide security model
  describe "authorization" do
    
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

        describe "when attempting to visit a protected page" do
          before do
            visit edit_user_path(user)
            fill_in "Email", with: user.email
            fill_in "Password", with: user.password
            click_button "Sign in"
          end

          describe "after signing in" do
            it "should render the desired protected page" do
              page.should have_selector('title', text: 'Edit User')
            end

            describe "when signing in again" do
              before do
                click_link "Sign out"
                click_link "Sign in"
                fill_in "Email", with: user.email
                fill_in "Password", with: user.password
                click_button "Sign in"
              end

              it "should render the profile page" do
                page.should have_selector('title', text: user.name)
              end
            end 
          end
        end

      describe "in the Users controller" do
        
        describe "visiting the edit page" do
          before { visit edit_user_path(user) }

          it { should have_selector('title', text: 'Sign in') }
          it { should have_selector('div.alert.alert-notice') }
        end

        describe "submiting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end
      end
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@ex.com") }
      before { sign_in user }

      # TEST(2A):
      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('title', text: 'Edit User') }
      end

      # TEST(2B):
      describe "submitting a PUT request to Users#update action" do
        before { put user_path(wrong_user) }
        it { response.should redirect_to(root_path) }
      end
    end
  end
end
