class SendUpdateToDiscordJob < ApplicationJob
  queue_as :default

  CHANNEL = Rails.application.credentials.discord_updates_channel

  def perform(update)
    return if CHANNEL.blank?

    client = Discordrb::API::Channel

    text = "**#{update.user.discord_username}**\n" \
           "#{update.date.strftime('%d.%m.%Y')}\n" \
           "**What have you done?**\n" \
           "#{update.made}\n" \
           "**What are you going to do tomorrow?**\n" \
           "#{update.planning}\n" \
           "**Problems?**\n" \
           "#{update.issues}"

    client.delete_message(discord_token, CHANNEL, update.discord_message_id) if update.discord_message_id.present?

    response = client.create_message(discord_token, CHANNEL, text)

    data = JSON.parse(response)

    update.update!(discord_message_id: data['id'])
  end
end
