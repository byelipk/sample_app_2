require 'spec_helper'

describe "Static pages" do
  # Define test subject
   subject { page }

   # TEST: Existence of home page
   describe "Home page" do
     before { visit root_path }

     it { should have_selector('h1',        text: 'Sample App') }
     it { should have_selector('title',     text: full_title('')) }
     it { should_not have_selector 'title', text: '| Home' }
   end

   # TEST: Existence of help page
   describe "Help page" do
     before { visit help_path }

     it { should have_selector('h1',    text: 'Help') }
     it { should have_selector('title', text: full_title('Help')) }
   end

   # TEST: Existence of about page
   describe "About page" do
     before { visit about_path }

     it { should have_selector('h1',    text: 'About') }
     it { should have_selector('title', text: full_title('About Us')) }
   end

   # TEST: Existence of contact page
   describe "Contact page" do
     before { visit contact_path }

     it { should have_selector('h1',    text: 'Contact') }
     it { should have_selector('title', text: full_title('Contact')) }
   end

   # Our expectations are that...
   it "should have the right links on the layout" do
     visit root_path
     click_link "About"
     page.should have_selector 'title', text: full_title('About Us')
     click_link "Help"
     page.should have_selector 'title', text: full_title('Help')
     click_link "Contact"
     page.should have_selector 'title', text: full_title('Contact')
     click_link "Home"
     click_link "Sign up now!"
     page.should have_selector 'title', text: full_title('Sign up')
     click_link "sample app"
     page.should have_selector 'h1', text: 'Sample App' 
   end
end