task :check_slack_updates => :environment do
  init
  history_messages =
    @client_slack.channels_history(
      channel: Rails.application.credentials.slack_channel)['messages']
  history_messages.each do |message|
    user = User.where(slack_id: message.user)
    id = user.first.id if user.present?
    if id.present?
      update_params = parse_message(message.text.tr("\n", ' ').squish)
      update_params[:slack_id] = message.user
      Update.create(update_params) if Update.where(update_params).blank?
    end
  end
end

  def init
    Slack.configure do |config|
      config.token = Rails.application.credentials.slack_api_token
    end
    @client_slack = Slack::Web::Client.new
  end

  def parse_message(message)
    regex = /^.[A-Z]*\s([0-9.]*)\s([a-zA-Z0-9,-_?*:'.\s]*)$/
    result = {}
    if message =~ regex
      result[:date] = Date.parse(Regexp.last_match[1])
      result[:text] = Regexp.last_match[2]
    end
    result
  end
