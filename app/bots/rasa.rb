class Rasa
  BASE_API = Rails.application.credentials.rasa_url

  attr_reader :user, :connection

  def initialize(user)
    @user = user

    @connection = Faraday.new BASE_API do |conn|
      conn.response :json, content_type: /\bjson$/
      conn.adapter Faraday.default_adapter
    end
  end

  class << self
    def ask(user, message, &block)
      new(user).ask(message, &block)
    end
  end

  def ask(message)
    return 'rasa_url undefined' if BASE_API.blank?
    TrackEvent.track(user, :ask_bot)

    url = "#{BASE_API}/webhooks/rest/webhook"
    data = {
      sender: user.id,
      message: message,
      metadata: {
        token: TokenService.instance.find_or_generate(user)
      }
    }
    response = connection.post(url, data.to_json, 'Content-Type': 'application/json')
    response.body.each { |item| yield(item) }
  end
end
