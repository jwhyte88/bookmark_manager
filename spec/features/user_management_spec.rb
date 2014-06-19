require 'spec_helper'

feature "User signs up" do

	# Strictly speaking, the tests that check the UI (have_content, etc.) should be separate from the test that check we what we have in the DB.
	# The reason is that you should test one thing at a time, whereas by mixing the two we're testing both the business Logic and the views.
	# However, let's not worry about this yet to keep the example simple


	scenario "when being logged out" do
		# Old - example - lambda { sign_up }.should change(User, :count).by(1)
		# New - example - expect{Counter.increment}.to change{Counter.count}.by(2)
		expect{ sign_up }.to change{User.count}.by(1) 
		expect(page).to have_content("Welcome, alice@example.com")
		expect(User.first.email).to eq("alice@example.com")
	end

	def sign_up(email = "alice@example.com", password = "oranges!")
		visit '/users/new'
		expect(page.status_code).to eq(200)
		expect(page.status_code).to eq(200)
		fill_in :email, :with => email
		fill_in :password, :with => password
		click_button "Sign up"
	end

end