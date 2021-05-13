namespace :service do
  desc 'Setup slack team id'
  task setup_slack_team_id: :environment do
    client = Slack::Web::Client.new

    User.where.not(slack_id: nil).each do |user|
      info = client.users_info(user: user[:slack_id])

      user.update! slack_team_id: info['user']['profile']['team'],
                   slack_name: info['user']['profile']['real_name_normalized']
    end
  end
end
