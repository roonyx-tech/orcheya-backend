Discord.configure do |config|
  config.channels = {
    updates: '496579059958939659',
    general: '491508851724648449',
    random: '598532306499797022',
    vacation: '587935058271404032',
    dayoff: '581050572204146691'
  }
  if Rails.application.credentials.discord_bot_token
    config.bot_token = "Bot #{Rails.application.credentials.discord_bot_token}"
  end
end
