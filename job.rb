require './models'
require './client'

class Job
  def self.perform
    Alert.all.each do |alert|
      current_sha = Client.head_sha(alert.owner, alert.repo, alert.branch)
      commits = Client.compare(alert.owner, alert.repo, alert.last_sha, current_sha)

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
