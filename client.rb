require 'octokit'

class Client
  def self.head_sha(owner, repo, branch)
    repository = "#{owner}/#{repo}"

    result = Octokit.ref(repository, "heads/#{branch}")
    current_sha = result.object.sha
  end

  def self.compare(owner, repo, first_sha, second_sha)
    repository = "#{owner}/#{repo}"

    commits = Octokit.compare(repository, first_sha, second_sha)
  end
end
