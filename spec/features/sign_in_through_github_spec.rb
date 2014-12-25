require 'rails_helper'
require 'support/github_credentials'
require 'support/sign_in_helpers'

feature 'Sign In Through Github' do
  include SignInHelpers

  scenario 'Signing in when I supply the right credentials', :external do
    visit '/'
    click_on 'Sign in with GitHub'
    within '#login' do
      fill_in 'Username or Email', with: GitHubCredentials.username
      fill_in 'Password', with: GitHubCredentials.password
      click_on 'Sign in'
    end
    click_on 'Authorize application' if page.has_content? 'Review permissions'
    expect(page).to_not have_content 'Sign in with GitHub'
    expect(page).to have_content GitHubCredentials.username
  end

  scenario 'Signing out', :external do
    sign_in!
    click_on 'Sign out'
    expect(page).to have_content 'Sign in with GitHub'
    expect(page).to_not have_content GitHubCredentials.username
  end

  scenario 'Fake signing in bypassing Github' do
    fake_sign_in!
    visit '/'
    expect(page).to_not have_content 'Sign in with GitHub'
    expect(page).to have_content 'github_username'
  end
end
