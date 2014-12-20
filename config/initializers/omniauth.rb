Rails.application.config.middleware.use OmniAuth::Builder do
  env = Rails.env.upcase
  key_name      = "#{env}_GITHUB_KEY"
  secret_name   = "#{env}_GITHUB_SECRET"
  github_key    = ENV[key_name]
  github_secret = ENV[secret_name]
  if github_key && github_secret
    provider :github, github_key, github_secret
  else
    fail "Please set #{key_name} and #{secret_name}"
  end
end
