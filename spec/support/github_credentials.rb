class GitHubCredentials
  class << self
    def username
      ENV['GITHUB_USERNAME'] || fail("Please set ENV['GITHUB_USERNAME']")
    end

    def password
      ENV['GITHUB_PASSWORD'] || fail("Please set ENV['GITHUB_PASSWORD']")
    end
  end
end
