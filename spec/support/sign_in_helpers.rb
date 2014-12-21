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

  def fake_sign_in!
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(sign_in_hash)
    visit '/auth/github'
    OmniAuth.config.test_mode = false
  end

  private

  def sign_in_hash
    {
      provider: 'github',
      uid: '0815',
      info: {
        full_name: 'GitHub User',
        nickname: 'github_username'
      }
    }
  end
end
