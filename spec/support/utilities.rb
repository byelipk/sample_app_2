include ApplicationHelper


RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: message)
  end
end

def sign_in(user)
	visit signin_path
	#page.should_not have_link('Profile')
	page.should_not have_link('Profile', href: user_path(user))  
    #page.should_not have_link('Settings') 
    page.should_not have_link('Settings' ,  href: edit_user_path(user)) 
	fill_in "Email",    with: user.email.upcase
	fill_in "Password", with: user.password
	click_button "Sign in"
	# Sign in when not using Capybara.
	cookies[:remember_token] = user.remember_token
end
