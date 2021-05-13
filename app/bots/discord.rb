require 'discordrb'

class Discord
  include ActiveSupport::Configurable

  def run
    token = Discord.config.bot_token
    return if token.blank?

    bot = Discordrb::Bot.new token: token
    bot.message { |event| handle_direct_message(event) }
    bot.mention do |event|
      event.message.react %w[😁 😅 😊 😌 😔].sample
    end

    bot.run
  end

  private

  def channel_message(channel, message)
    token = Discord.config.bot_token
    channel_id = Discord.config.channels[channel.to_sym]
    return if token.blank? || channel_id.blank? || message.blank?

    Discordrb::API::Channel.create_message(token, channel_id, message)
  end

  def custom_respond(user, event, custom)
    return if custom.blank?

    event.message.react(custom['react']) if custom['react'].present?
    return if custom['text'].blank?
    message = render_message(custom['text'], user)

    if custom['channel'].eql?('dm')
      event.respond(message)
    else
      channel_message(custom['channel'], message)
    end
  end

  def handle_direct_message(event)
    return unless event.channel.type == Discordrb::Channel::TYPES[:dm]

    user = User.find_by discord_id: event.user.id
    if user
      Rasa.ask(user, event.message.content) { |item| custom_respond(user, event, item['custom']) }
    else
      event.respond(text_please_connect)
    end
  end

  def text_please_connect
    "Привет, если хочешь поговорить со мной, то тебе нужно подключить Discord!\n"\
    "Это можно сделать в настройках вашего профиля #{Rails.application.credentials.frontend_url}/profile?tab=settings"
  end

  def render_message(source, user)
    template = Liquid::Template.parse(source) # Parses and compiles the template
    template.render(
      'name' => user.name,
      'surname' => user.surname,
      'full_name' => user.full_name
    )
  end
end
