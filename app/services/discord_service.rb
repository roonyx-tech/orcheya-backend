class DiscordService
  class << self
    def connect(user, discord_data)
      data = Discordrb::API::User.profile("Bearer #{discord_data[:access_token]}")

      info_data = JSON.parse(data)

      bot_token = "Bot #{Rails.application.credentials.discord_bot_token}"

      dm = Discordrb::API::User.create_pm(bot_token, info_data['id'])

      info_dm = JSON.parse(dm)

      user.update!(discord_token: discord_data[:access_token],
                   discord_refresh_token: discord_data[:refresh_token],
                   discord_id: info_data['id'],
                   discord_username: info_data['username'],
                   discord_dm_id: info_dm['id'])

      first_message(user)
    end

    def disconnect(user)
      user.update!(discord_token: nil,
                   discord_refresh_token: nil,
                   discord_id: nil,
                   discord_username: nil,
                   discord_dm_id: nil)
    end

    private

    def first_message(user)
      text = "Hi, #{user.name}! I’m a Roonyx bot." \
             'I will automatically remind you about writing an update every day,' \
             '30 minutes before your working day is over.' \
             'Or, you can call me out in any chat with the command `/update` or `@roonyx`'

      DiscordPostMessageJob.perform_later user, text
    end
  end
end
