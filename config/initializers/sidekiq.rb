require 'sidekiq/web'
include Pundit

Sidekiq.configure_server do |config|
  if ENV['REDIS_HOST']
    config.redis = { url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}" }
  else
    config.redis = { url: 'redis://localhost:6379/12' }
  end
  Rails.logger = Sidekiq::Logging.logger
  database_url = ENV['POSTGRES_URL']
  if database_url
    ENV['POSTGRES_URL'] = "#{database_url}?pool=#{ENV['POSTGRES_POOL']}"
    ActiveRecord::Base.establish_connection
  end
end

Sidekiq.configure_client do |config|
  if ENV['REDIS_HOST']
    config.redis = { url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}" }
  else
    config.redis = { url: 'redis://localhost:6379/12' }
  end
end

Sidekiq::Web.use Rack::Auth::Basic do |email, password|
  @user = User.find_by(email: email)

  def current_user
    @user
  end

  if @user
    a = BCrypt::Password.new(@user.encrypted_password) == password
    b = authorize @user, :sidekiq_management?

    a & b
  else
    false
  end
end
