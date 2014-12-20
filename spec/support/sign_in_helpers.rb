require 'support/github_credentials'

module SignInHelpers
  def sign_in!
    visit '/'
    click_on 'Sign in with GitHub'
    within '#login' do
      fill_in 'Username or Email', with: GitHubCredentials.username
      fill_in 'Password', with: GitHubCredentials.password
      click_on 'Sign in'
    end
    click_on 'Authorize application' if page.has_content? 'Review permissions'
  end
end
