class ApplicationJob < ActiveJob::Base
  def discord_token
    "Bot #{Rails.application.credentials.discord_bot_token}"
  end
end
