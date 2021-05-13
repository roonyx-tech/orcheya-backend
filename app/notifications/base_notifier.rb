class BaseNotifier
  attr_reader :recipient, :options

  def initialize(options = {})
    @options = OpenStruct.new(options)
    @recipient = options[:recipient]
  end

  def render_message(action, render_options = {})
    template = render_options[:template] || begin
      folder = self.class.name.underscore[0..-10]
      path = Rails.root.join('app', 'views', 'notifications', folder, action.to_s + '.erb')
      File.read(path)
    end
    ERB.new(template).result(binding).strip.gsub(/^\s*$/, '').squeeze("\n")
  end

  def link(path)
    "#{Rails.application.credentials.frontend_url}/#{path}"
  end

  def notify(render_options = {})
    action = render_options[:action] || caller_locations(1..1).first.label
    @recipient = render_options[:recipient] if render_options[:recipient]
    message = render_message(action, render_options)
    post(recipient, message)
  end

  def channel_notify(render_options = {})
    action = render_options[:action]
    channel_recipient = Discord.config.channels[render_options[:channel]]
    return if channel_recipient.blank?

    message = render_message(action, render_options)
    post(channel_recipient, message)
  end

  def post(recipient, message)
    DiscordPostMessageJob.perform_later(recipient, message)
    message
  end

  class << self
    # :nocov:
    def notify(action, options = {})
      notifier = new(options)
      notifier.send(action) if notifier.respond_to? action
    end
    # :nocov:
  end
end
