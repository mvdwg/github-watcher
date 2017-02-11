require 'octokit'
require 'models'

class Job
  def self.perform
    Alert.all.each do |alert|
      repository = "#{alert.owner}/#{alert.repo}"

      result = Octokit.ref(repository, "heads/#{alert.branch}")
      current_sha = result.object.sha

      commits = Octokit.compare(repository, alert.last_sha, current_sha)

      if commits.files.any?{|file| file.filename == alert.path }
        Alarm.create(
          alert_id: alert.id,
          status: "unresolved",
          first_sha: alert.last_sha,
          second_sha: current_sha
        )
      end

      alert.update(last_sha: current_sha)
    end
  end
end

Job.perform
