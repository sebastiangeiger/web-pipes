class GitHubCredentials
  class << self
    def username
      ENV['GITHUB_USERNAME'] or raise "Please set ENV['GITHUB_USERNAME']"
    end
    def password
      ENV['GITHUB_PASSWORD'] or raise "Please set ENV['GITHUB_PASSWORD']"
    end
  end
end
