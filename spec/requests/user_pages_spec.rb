require 'spec_helper'

describe "User pages" do

  # Define the test subject
  subject { page } 

  # Test the sign-up page
  describe "signup page" do
    # First, we need to follow the path to page
    before { visit signup_path }

    # Our expectations are that...
    it { should have_selector('h1',    text: 'Sign up') }
    it { should have_selector('title', text: full_title('Sign up')) }
  end

  # Test the profile page
  describe "profile page" do
    # We need a test user to run this test
    let(:user) { FactoryGirl.create(:user) }
    # Follow the path to page
    before { visit user_path(user) }

    # Our expectations are that...
    it { should have_selector('h1',    text: user.name) }
    it { should have_selector('title', text: user.name) }
  end   

  # Test our signup process
  describe "signup" do
      # Follow the path to page
      before { visit signup_path }
      # Create instance variable targeting the submit button
      let(:submit) { "Create my account" }

      # Describe the process when we submit invalid data
      describe "with invalid information" do
        
        # With invalid user data...
        it "should not create a user" do
          # clicking submit will not increse the user count by 1
          expect { click_button submit }.not_to change(User, :count)
        end

        # What happens after submitting invalid user data?
        describe "after submission" do
          # Click the submit button
          before { click_button submit }

          # Our expectations are that...
          it { should have_selector('title', text: 'Sign up') }
          it { should have_content('error') }
        end 
      end

      # Describe the process when we submit valid data
      describe "with valid information" do
        
        # Fill out the form fields with valid user data
        before do
          fill_in "Name",         with: "Example User"
          fill_in "Email",        with: "user@example.com"
          fill_in "Password",     with: "foobar"
          fill_in "Confirmation", with: "foobar"
        end

        # With valid user data...
        it "should create a user" do
          # clicking submit should increase the user count by 1
          expect { click_button submit }.to change(User, :count).by(1)
        end

        # What happens after submitting valid user data?
        describe "after saving a user" do
          # Click on submit
          before { click_button submit }
          # Create new test user
          let(:user) { User.find_by_email("user@example.com") }

          # Our expectations are that...
          it { should have_selector('title', text: user.name) }
          it { should have_selector('div.alert.alert-success', text: 'Welcome') }
          it { should have_link('Sign out') }
        end
      end
  end

  # Test the edit page
  describe "edit" do
    
    # Create new test user
    let(:user) { FactoryGirl.create(:user) }

    # Follow path to page
    before do 
      sign_in user
      visit edit_user_path(user)
    end

    # Test the edit page
    describe "page" do
      
      # Our expectations are that...
      it { should have_selector('h1', text: "Update your profile") }
      it { should have_selector('title', text: "Edit User") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    # With invalid user data (i.e. empty form fields)...
    describe "with invalid information" do
      
      # Click the update button
      before { click_button "Save changes" }
      
      # Our expectations are that
      it { should have_content "error" }
    end

    # With valid user data...
    describe "with valid information" do

      # Create new name & email
      let(:new_name) { "New name" }
      let(:new_email) { "new@email.org" }

       # Fill out form, then follow path to page
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password 
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      # Our expectations are that...
      it { should have_selector('title', text: new_name) }
      it { should have_link('Sign out', href: signout_path) }
      it { should have_selector('div.alert.alert-success') }
      # Explicitly change subject of test from page to user
      specify { user.reload.name.should  == new_name }
      specify { user.reload.email.should == new_email }
    end
  end
end
