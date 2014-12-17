Rails.application.config.middleware.use OmniAuth::Builder do
  github_key = ENV['GITHUB_KEY']
  github_secret = ENV['GITHUB_SECRET']
  if github_key and github_secret
    provider :github, github_key, github_secret
  else
    raise "Please set GITHUB_KEY and GITHUB_SECRET"
  end
end
