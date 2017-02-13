require 'dotenv/load'

require './models'
require './client'

class Job
  def self.perform
    Alert.all.each do |alert|
      current_sha = Client.head_sha(alert.owner, alert.repo, alert.branch)
      commits = Client.compare(alert.owner, alert.repo, alert.last_sha, current_sha)

      if commits.files.any?{|file| file.filename == alert.path }
        alarm = Alarm.create(
          alert_id: alert.id,
          status: "unresolved",
          first_sha: alert.last_sha,
          second_sha: current_sha
        )

        send_notification(alarm)
      end

      alert.update(last_sha: current_sha)

    end
  end

  def self.send_notification(alarm)
    alert = alarm.alert
    user = alert.user

    if user.email
      client = Postmark::ApiClient.new(ENV["POSTMARK_API_TOKEN"])
      client.deliver(
        from: 'info@mvdwg.xyz',
        to: user.email,
        subject: 'Github Watcher - Notification',
        text_body: "
#{alert.owner} | #{alert.repo}
#{alert.path} has changed

https://github.com/#{alert.owner}/#{alert.repo}/compare/#{alarm.first_sha}...#{alarm.second_sha}
        "
      )
    end
  end
end

Job.perform
