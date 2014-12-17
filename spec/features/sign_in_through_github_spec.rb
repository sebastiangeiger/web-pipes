require 'rails_helper'
require 'support/github_credentials'

feature "Sign In Through Github" do

  scenario "when I supply the right credentials", :external do
    visit "/"
    click_on "Sign in with GitHub"
    within '#login' do
      fill_in "Username or Email", with: GitHubCredentials.username
      fill_in "Password", with: GitHubCredentials.password
      click_on "Sign in"
    end
    if page.has_content? "Review permissions"
      click_on "Authorize application"
    end
  end

end
