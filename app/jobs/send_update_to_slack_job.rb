class SendUpdateToSlackJob < ApplicationJob
  queue_as :default

  CHANNEL = Rails.application.credentials.slack_updates_channel

  def perform(update)
    client = Slack::Web::Client.new

    text = "*#{update.user.slack_name}*\n" \
           "#{update.date.strftime('%d.%m.%Y')}\n" \
           "*What have you done?*\n" \
           "#{update.made}\n" \
           "*What are you going to do tomorrow?*\n" \
           "#{update.planning}\n" \
           "*Problems?*\n" \
           "#{update.issues}"

    client.chat_delete channel: CHANNEL, ts: update.slack_ts if update.slack_ts

    response = client.chat_postMessage channel: CHANNEL,
                                       text: text,
                                       as_user: true

    update.update!(slack_ts: response[:message][:ts])
  end
end
