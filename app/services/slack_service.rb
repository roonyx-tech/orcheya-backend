class SlackService
  class << self
    def connect(user, slack_data)
      client = Slack::Web::Client.new
      info = client.users_info(user: slack_data[:user_id])

      user.update! slack_id: slack_data[:user_id],
                   slack_team_id: slack_data[:team_id],
                   slack_name: info['user']['profile']['real_name_normalized'],
                   slack_token: slack_data[:access_token],
                   temp_integration_token: nil,
                   temp_referer: nil
    end

    def disconnect(user)
      user.update! slack_id: nil,
                   slack_token: nil,
                   slack_name: nil,
                   slack_team_id: nil
    end
  end
end
