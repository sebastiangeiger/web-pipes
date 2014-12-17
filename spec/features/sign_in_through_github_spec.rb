require 'rails_helper'

feature "Sign In Through Github" do

  scenario "when I supply the right credentials", :external do
    visit "/"
    click_on "Sign in with GitHub"
    within '#login' do
      fill_in "Username or Email", with: ENV['GITHUB_USERNAME']
      fill_in "Password", with: ENV['GITHUB_PASSWORD']
      click_on "Sign in"
    end
    if page.has_content? "Review permissions"
      click_on "Authorize application"
    end
  end

end
