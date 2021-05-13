class DiscordPostMessageJob < ApplicationJob
  queue_as :default

  def perform(addressee, text)
    channel = case addressee
              when User
                addressee.discord_connected? && addressee.discord_dm_id
              when String
                addressee
              else
                raise "Bad addressee #{addressee}"
              end
    token = Discord.config.bot_token
    Discordrb::API::Channel.create_message(token, channel, text) if channel && token
  end
end
