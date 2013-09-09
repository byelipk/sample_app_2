require 'spec_helper'

describe "Authentication" do

  # Define the test subject
  subject { page }

  # TEST: Existence of sign-in page
  describe "signin page" do

    before { visit signin_path }

    it { should have_selector('h1',    text: 'Sign in') }
    it { should have_selector('title', text: 'Sign in') }
  end

  # TEST: Sign-in process
  describe "signin" do
  	before { visit signin_path }

  	describe "with invalid information" do
  		before { click_button "Sign in" }
  		it { should have_selector('title',                 text: 'Sign in') }
  		it { should have_selector('div.alert.alert-error', text: 'Invalid') }


	    describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end	
  	end

    describe "with valid information" do

      let(:user) { FactoryGirl.create(:user) }
      # Method: sign_in is found in utilities.rb
      before { sign_in user }
      it { should have_selector('title',   text: user.name) }
      it { should have_link('Profile',     href: user_path(user)) }
      it { should have_link('Sign out',    href: signout_path) }
      it { should have_link('Settings',    href: edit_user_path(user)) }
      it { should have_link('Users',       href: users_path) }
      it { should_not have_link('Sign in', href: signin_path) }


      describe "followed by signout" do
        before { click_link "Sign out" }
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
            fill_in "Email",    with: user.email
            fill_in "Password", with: user.password
            click_button "Sign in"
          end

          describe "after signing in" do
            it "should render the desired protected page" do
              page.should have_selector('title', text: 'Edit User')
            end

            describe "when signing in again" do
              before do
                delete signout_path
                visit signin_path
                fill_in "Email",    with: user.email
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

        describe "visiting the user index" do
          before { visit users_path }
          it {should have_selector('title', text: 'Sign in')}
        end
      end
    end

    describe "in the microposts controller" do

      describe "submitting a post request to the create action" do
        before { post microposts_path }
        specify { response.should redirect_to(signin_path) }
      end

      describe "submitting a destroy request to the delete action" do
        before { delete micropost_path(FactoryGirl.create(:micropost)) }
        specify { response.should redirect_to(signin_path) }
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

    describe "as non-admin users" do
      let(:user) {FactoryGirl.create(:user)}
      let(:non_admin) {FactoryGirl.create(:user)}

      before { sign_in non_admin }

      describe "subbmiting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }
      end
    end
  end
end
